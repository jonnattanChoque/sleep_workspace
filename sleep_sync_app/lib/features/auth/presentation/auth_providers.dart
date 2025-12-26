import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/domain/app_user.dart';
import 'package:sleep_sync_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/presentation/controllers/auth_controller.dart';

// 1. El Repositorio (Capa de Datos)
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

// 2. El Stream del Estado (Capa de Dominio/App)
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChanged;
});

// 3. El Controlador de la UI (Capa de Presentación)
// Este es el que usas en el LoginScreen para llamar a login() o signUp()
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});