import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/auth/presentation/screens/login_screen.dart';
import 'package:sleep_sync_app/features/auth/presentation/screens/verification_pending_screen.dart';
import 'package:sleep_sync_app/features/link/presentation/screens/dashboard_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          if (!user.verifiedEmail!) {
            return const VerificationPendingScreen();
          }
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('Error crítico: $e')),
      ),
    );
  }
}