import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/auth/domain/auth_failure.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

/// 1. Definición del Estado de la Autenticación
class AuthState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final Color background;
  final DateTime? timestamp;

  AuthState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.background = Colors.transparent,
    this.timestamp,
  });

  factory AuthState.initial() => AuthState();

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    Color? background,
    bool? isEmailVerificationSent,
    DateTime? timestamp,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      background: background ?? this.background,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.initial());

  Future<void> signUp(String email, String password, String name) async {
    if (!_validate(email, password, name)) return;

    _initState();
    
    try {
      await _authRepository.signUpWithEmail(email.trim(), password.trim());
      state = state.copyWith(
        isLoading: false, 
        isEmailVerificationSent: true,
        successMessage: AppStrings.verificationSent,
        background: TwonColors.success,
        timestamp: DateTime.now()
      );
    } catch (e) {
      _setErrorState(_mapFailureToMessage(e));
    }
  }

  Future<void> login(String email, String password) async {
    if (!_validate(email, password)) return;
    _initState();

    try {
      await _authRepository.signInWithEmail(email.trim(), password.trim());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      _setErrorState(_mapFailureToMessage(e));
    }
  }

  Future<void> loginWithGoogle() async {
    _initState();

    try {
      await _authRepository.signInWithGoogle();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      _setErrorState(_mapFailureToMessage(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      _setErrorState(AppStrings.errorInvalidEmail);
      return;
    }

    _initState();
    try {
      await _authRepository.sendPasswordResetEmail(email.trim());
      state = state.copyWith(
        isLoading: false, 
        successMessage: AppStrings.resetPasswordSent,
        background: TwonColors.success,
        timestamp: DateTime.now()
      );
    } catch (e) {
      _setErrorState(_mapFailureToMessage(e));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
  
  void resetState() {
    state = AuthState.initial();
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
    state = state.copyWith(
      isLoading: false, 
      error: message, 
      background: TwonColors.error,
      timestamp: DateTime.now()
    );
  }

  void _setErrorState(String message) {
    state = state.copyWith(
      isLoading: false,
      error: message,
      background: TwonColors.error,
      timestamp: DateTime.now(),
    );
  }

  void _initState() {
    state = state.copyWith(
      isLoading: true, 
      error: null,
      successMessage: null,
      background: Colors.transparent,
    );
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
    };
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider); 
  return AuthController(repository);
});