import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/domain/enums/auth_failure.dart';

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final IAuthRepository _authRepository;
  StreamSubscription<AppUser?>? _userSubscription;

  AuthController(this._authRepository) : super(const AsyncValue.data(null)) {
    _listenToUserChanges();
  }

  void _listenToUserChanges() {
    _userSubscription?.cancel();
    _userSubscription = _authRepository.onAuthStateChanged.listen((user) {
      if (mounted) {
        state = AsyncValue.data(user);
      }
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  Future<void> signUp(String email, String password, String name) async {
    if (!_validate(email, password, name)) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() async {
      try {
        await _authRepository.signUpWithEmail(email.trim(), password.trim(), name.trim());
        return null;
      } catch (e) {
        throw _mapFailureToMessage(e);
      }
    });
  }

  Future<void> login(String email, String password) async {
    if (!_validate(email, password)) return;
  
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() async {
      try {
        await _authRepository.signInWithEmail(email.trim(), password.trim());
        return null;
      } catch (e) {
        throw _mapFailureToMessage(e);
      }
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() async {
      try {
        await _authRepository.signInWithGoogle();
        return null;
      } catch (e) {
        throw _mapFailureToMessage(e);
      }
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      state = AsyncError(AppStrings.errorInvalidEmail, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard<AppUser?>(() async {
      try {
        await _authRepository.sendPasswordResetEmail(email.trim());
        return null;
      } catch (e) {
        throw _mapFailureToMessage(e);
      }
    });
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
  
  // Private functions
  bool _validate(String email, String password, [String? name]) {
    if (name != null && name.isEmpty) {
      _sendValidate(AppStrings.errorEmptyFields);
      return false;
    }
    if (email.isEmpty || password.isEmpty) {
      _sendValidate(AppStrings.errorEmptyFields);
      return false;
    }
    if (!email.contains('@')) {
      _sendValidate(AppStrings.errorInvalidEmail);
      return false;
    }
    if (password.length < 6) {
      _sendValidate(AppStrings.errorShortPassword);
      return false;
    }
    return true;
  }

  void _sendValidate(String message) {
    state = AsyncError(message, StackTrace.current);
  }

  String _mapFailureToMessage(Object e) {
    if (e is! AuthFailure) return AppStrings.errorGeneral;

    return switch (e) {
      AuthFailure.invalidEmail      => AppStrings.errorInvalidEmail,
      AuthFailure.userNotFound      => AppStrings.errorUserNotFound,
      AuthFailure.wrongPassword     => AppStrings.errorWrongPassword,
      AuthFailure.emailAlreadyInUse => AppStrings.errorEmailAlreadyInUse,
      AuthFailure.networkError      => AppStrings.errorNetwork,
      AuthFailure.cancelledByUser   => AppStrings.errorCancelled,
      AuthFailure.unknown           => AppStrings.errorGeneral,
      AuthFailure.invalidCredential => AppStrings.invalidCredential,
    };
  }
}