import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class VerificationPendingScreen extends ConsumerWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 100, color: TwonDSColors.accentMoon),
            const SizedBox(height: 32),
            const Text(
              AppStrings.verificationTitle,
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.verificationMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              child: const Text(AppStrings.backToLogin, style: TextStyle(color: TwonDSColors.accentMoon)),
            ),
          ],
        ),
      ),
    );
  }
}