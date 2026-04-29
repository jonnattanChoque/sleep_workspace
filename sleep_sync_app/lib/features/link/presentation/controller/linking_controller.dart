import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  final canSendNudgeProvider = StateProvider<bool>((ref) => true);
  Timer? _buzzTimer;

  LinkingController(this._repository, this.ref, this.userSleepGoal) : super(const AsyncData(null));

  int calculateQuality(double hours) {
    if (userSleepGoal <= 0) return 3;
    return ((hours / userSleepGoal) * 5).clamp(1, 5).round();
  }

  String formatHours(double hours) {
    return hours % 1 == 0 
        ? hours.toInt().toString() 
        : hours.toStringAsFixed(1);
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
    final String percent = formatHours(progress * 100);

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
      ref.read(canSendNudgeProvider.notifier).state = true;
      debugPrint("Error: $e");
    } finally {
      Future.delayed(const Duration(minutes: 1), () {
        if (ref.read(canSendNudgeProvider.notifier).state == false) {
           ref.read(canSendNudgeProvider.notifier).state = true;
        }
      });
    }
}

  Future<void> resetStreak(String userId) async {
    try {
      await _repository.resetStreak(userId);
    } catch (e) {
      debugPrint("Error resetting streak: $e");
    }
  }

  Future<void> saveRecord(double hours) async {
    final currentUser = ref.read(authControllerProvider).value;
    if (currentUser == null) return;
    final String? partnerId = currentUser.partnerId;
    final partnerUser = partnerId != null 
      ? ref.read(partnerProvider).value
      : null;
    state = const AsyncLoading();

    try {
      final now = DateTime.now();
      final String todayId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final yesterday = now.subtract(const Duration(days: 1));
      final String yesterdayId = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      final int quality = calculateQuality(hours);
      final stats = currentUser.stats;

      final existingLogs = ref.read(sleepLogsProvider(currentUser.uid)).value ?? [];
      final SleepRecord? oldRecord = existingLogs.any((r) => r.id == todayId) 
          ? existingLogs.firstWhere((r) => r.id == todayId) 
          : null;

      final bool isUpdate = oldRecord != null;
      final partnerStats = partnerUser?.stats;
      int updatedStreak = stats?.streak ?? 0;
      if (!isUpdate) {
        bool iAmConsistent = currentUser.stats?.lastLogDate == yesterdayId;
        bool partnerIsConsistent = partnerStats?.lastLogDate == yesterdayId || 
                                partnerStats?.lastLogDate == todayId;

        if (iAmConsistent && partnerIsConsistent) {
          updatedStreak += 1;
        } else {
          updatedStreak = 1; 
        }
      }

      double newTotalHours = stats?.totalHours ?? 0 + hours;
      int newTotalQuality = stats?.totalQualityStars ?? 0  + quality;
      int newTotalRecords = stats?.totalRecords ?? 0  + (isUpdate ? 0 : 1);

      if (isUpdate) {
        newTotalHours -= oldRecord.hours;
        newTotalQuality -= oldRecord.quality;
      }

      final updatedUser = currentUser.copyWith(
        stats: UserStats(
          totalHours: newTotalHours,
          totalQualityStars: newTotalQuality,
          totalRecords: newTotalRecords,
          avgHours: newTotalHours / newTotalRecords,
          avgQuality: (newTotalQuality / newTotalRecords).toDouble(),
          streak: updatedStreak,
          lastLogDate: todayId,
        ),
      );

      final record = SleepRecord(
        id: todayId, 
        userId: currentUser.uid,
        date: now,
        hours: hours,
        quality: quality,
      );

      await _repository.addSleepRecord(record, updatedUser);
      
    if (!mounted) return;
      state = const AsyncData("Registro guardado con éxito");
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void startBuzzCooldown() {
    ref.read(buzzCooldownTimerProvider.notifier).state = 120;

    _buzzTimer?.cancel();
    _buzzTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = ref.read(buzzCooldownTimerProvider);
      
      if (currentState > 0) {
        ref.read(buzzCooldownTimerProvider.notifier).state = currentState - 1;
      } else {
        timer.cancel();
      }
    });
  }
}