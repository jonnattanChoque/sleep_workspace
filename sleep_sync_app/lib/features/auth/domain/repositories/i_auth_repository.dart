import 'package:sleep_sync_app/features/auth/domain/app_user.dart';

abstract class IAuthRepository {
  Stream<AppUser?> get onAuthStateChanged;
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
}