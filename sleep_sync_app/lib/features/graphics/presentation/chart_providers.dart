import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/graphics/data/repositories/sleep_chart_repository.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/sleep_chart.dart';
import 'package:sleep_sync_app/features/graphics/domain/repositories/i_sleep_chart_repository.dart';
import 'package:sleep_sync_app/features/graphics/presentation/controller/sleep_chart_controller.dart';

final sleepRepositoryProvider = Provider<ISleepChartRepository>((ref) {
  return SleepChartRepository();
});

final sleepChartControllerProvider = StateNotifierProvider.family<SleepChartController, AsyncValue<SleepChartStateData>, String>((ref, partnerUid) {
  final repo = ref.watch(sleepRepositoryProvider);
  final myUid = ref.watch(authControllerProvider).value?.uid ?? "";
  return SleepChartController(repo, myUid, partnerUid);
});