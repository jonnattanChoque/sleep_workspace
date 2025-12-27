import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/presentation/controllers/auth_controller.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChanged;
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});