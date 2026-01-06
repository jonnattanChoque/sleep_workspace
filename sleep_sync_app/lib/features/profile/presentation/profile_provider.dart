import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/profile/data/firebase_profile_repository.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:sleep_sync_app/features/profile/presentation/controllers/profile_controller.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return FirebaseProfileRepository();
});

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});