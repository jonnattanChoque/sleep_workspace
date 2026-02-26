import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/link/data/repository/remote_config_repository.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_remote_config_repository.dart';
import 'package:sleep_sync_app/features/link/presentation/controller/dashboard_controller.dart';

final remoteConfigRepositoryProvider = Provider<IRemoteConfigRepository>((ref) {
  return RemoteConfigRepository();
});

final dashboardControllerProvider = StateNotifierProvider<DashboardController, bool>((ref) {
  final repository = ref.watch(remoteConfigRepositoryProvider);
  return DashboardController(repository);
});