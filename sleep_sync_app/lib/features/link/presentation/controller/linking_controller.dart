import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/utils/enum_lottie.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_chart_model.dart';
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

  SleepChartState transformToUIState(List<SleepRecord> logs, String userId) {
    final today = DateTime.now();
    final todayId = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // 1. Buscamos el registro
    final record = logs.firstWhere(
      (r) => r.userId == userId && r.id == todayId,
      orElse: () => SleepRecord.empty(userId),
    );

    // 2. Cálculos de negocio
    final double rawProgress = record.goal > 0 ? (record.hours / record.goal) : 0.0;
    final double progress = rawProgress.clamp(0.0, 1.0);
    final String percent = (progress * 100).toString();

    final (lottie, color) = switch (record.quality) {
      5 => (StateLottie.good.path, Colors.greenAccent),
      4 => (StateLottie.good.path, Colors.lightGreenAccent),
      3 => (StateLottie.neutral.path, Colors.orangeAccent),
      2 => (StateLottie.neutral.path, Colors.orange),
      1 => (StateLottie.bad.path, Colors.redAccent),
      0 => (StateLottie.searching.path, Colors.grey.withValues(alpha: 0.5)),
      _ => (StateLottie.searching.path, Colors.grey.withValues(alpha: 0.2)),
    };

    return SleepChartState(
      progress: progress,
      lottiePath: lottie,
      chartColor: color,
      hours: record.hours,
      percent: percent
    );
  }

  bool hasRecordForToday(List<SleepRecord> logs) {
    final todayId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return logs.any((record) => record.id == todayId);
  }

  Future<void> sendNudge({
    required String toUserId, 
    required String fromUserName
  }) async {
    try {
      await _repository.sendNudge(toUserId, fromUserName);
    } catch (e) {
      debugPrint("Error: $e");
    }
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
        userId: currentUser.uid,
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