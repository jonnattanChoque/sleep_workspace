import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/profile/data/firebase_profile_repository.dart';
import 'package:sleep_sync_app/features/profile/domain/enum/profile_failure.dart';
import 'package:sleep_sync_app/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:sleep_sync_app/features/profile/presentation/controllers/profile_controller.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return FirebaseProfileRepository();
});

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<ProfileActionState>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileController(repo, ref);
});

final partnerInfoVisibleProvider = StateProvider<bool>((ref) => false);