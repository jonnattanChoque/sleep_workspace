import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/unlink/data/repository/firebase_unlinking_repository.dart';
import 'package:sleep_sync_app/features/unlink/domain/repository/i_unlinking_repository.dart';
import 'package:sleep_sync_app/features/unlink/presentation/controllers/unlinking_controller.dart';

final unlinkingRepositoryProvider = Provider<IUnlinkingRepository>((ref) {
  return FirebaseUnlinkingRepository();
});

final unlinkingControllerProvider = StateNotifierProvider<UnlinkingController, AsyncValue<String?>>((ref) {
  final repository = ref.watch(unlinkingRepositoryProvider);
  return UnlinkingController(repository, ref);
});
