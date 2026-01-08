import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/data/repository/firebase_linking_repository.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';
import 'package:sleep_sync_app/features/link/domain/repository/i_linking_repository.dart';
import 'package:sleep_sync_app/features/link/presentation/controller/linking_controller.dart';

final linkingRepositoryProvider = Provider<IlinkingRepository>((ref) {
  return FirebaseLinkingRepository();
});

final sleepLogsProvider = StreamProvider<List<SleepRecord>>((ref) {
  return ref.watch(linkingRepositoryProvider).onSleepLogsChanged;
});

final linkingControllerProvider = StateNotifierProvider<LinkingController, AsyncValue<String?>>((ref) {
  final user = ref.watch(authControllerProvider).value;
  final currentSleepGoal = user?.sleepGoal ?? 8.0;
  final repository = ref.watch(linkingRepositoryProvider);
  return LinkingController(repository, ref, currentSleepGoal);
});
