import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_linking_repository.dart';
import 'package:sleep_sync_app/features/link/presentation/linking_provider.dart';

class LinkingController extends StateNotifier<AsyncValue<String?>> {
  final IlinkingRepository _repository;
  final Ref ref;
  final double userSleepGoal;

  LinkingController(this._repository, this.ref, this.userSleepGoal) : super(const AsyncData(null));

  int calculateQuality(double hours) {
    if (userSleepGoal <= 0) return 3;
    return ((hours / userSleepGoal) * 5).clamp(1, 5).round();
  }

  Future<void> saveRecord(double hours) async {
    final currentUser = ref.read(authControllerProvider).value;
    if (currentUser == null) return;
    state = const AsyncLoading();

    try {
      final now = DateTime.now();
      final String docId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final quality = calculateQuality(hours);

      final existingLogs = ref.read(sleepLogsProvider).value ?? [];
      final bool isUpdate = existingLogs.any((r) => r.id == docId);
      final SleepRecord? oldRecord = isUpdate ? existingLogs.firstWhere((r) => r.id == docId) : null;
      
      double newTotalHours = currentUser.stats.totalHours + hours;
      int newTotalQuality = currentUser.stats.totalQualityStars + quality;
      int newTotalRecords = currentUser.stats.totalRecords + (isUpdate ? 0 : 1);

      if (isUpdate && oldRecord != null) {
        newTotalHours -= oldRecord.hours;
        newTotalQuality -= oldRecord.quality;
      }

      final updatedUser = currentUser.copyWith(
        stats: UserStats(
          totalHours: newTotalHours,
          totalQualityStars: newTotalQuality,
          totalRecords: newTotalRecords,
          avgHours: newTotalHours / newTotalRecords,
          avgQuality: newTotalQuality / newTotalRecords,
        ),
      );

      final record = SleepRecord(
        id: docId, 
        date: now,
        hours: hours,
        quality: quality,

      );
      await _repository.addSleepRecord(record, updatedUser);
      
      state = const AsyncData(AppStrings.registerSleepSuccess);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}