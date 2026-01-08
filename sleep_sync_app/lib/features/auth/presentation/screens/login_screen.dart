// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _showTwonSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    TwnDSMessage.show(context, message.toString(), isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        _showTwonSnackBar(
          context, 
          next.error.toString(), 
          true,
        );
      }

      if (previous is AsyncLoading && next is AsyncData) {
        if (!isLogin) {
          _showTwonSnackBar(context, AppStrings.verificationSent, false);
        } else if (emailController.text.isNotEmpty && passwordController.text.isEmpty) {
          _showTwonSnackBar(context, AppStrings.resetPasswordSent, false);
        }
      }
    });
    
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.title,
                style: TwonDSTextStyles.brandLogo(context)
              ),
              const SizedBox(height: 8),
              const Icon(TwonDSIcons.sleep, size: 80, color: TwonDSColors.accentMoon),
              const SizedBox(height: 32),
              Text(
                isLogin ? AppStrings.loginWelcome : AppStrings.registerTitle,
                style: TwonDSTextStyles.h1(context),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: !isLogin 
                  ? Column(
                      key: const ValueKey('nameField'),
                      children: [
                        TwonDSTextField(
                          hint: AppStrings.nameHint, 
                          icon: TwonDSIcons.profile, 
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox(key: ValueKey('empty')),
              ),
              TwonDSTextField(hint: AppStrings.emailLabel, icon: TwonDSIcons.email, controller: emailController),
              const SizedBox(height: 16),
              TwonDSTextField(hint: AppStrings.passwordLabel, icon: TwonDSIcons.lock, controller: passwordController, isPassword: true),
              const SizedBox(height: 10),
              isLogin
                ? Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: authState.isLoading 
                          ? null 
                          : () {
                              final controller = ref.read(authControllerProvider.notifier);
                              controller.sendPasswordResetEmail(emailController.text);
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppStrings.forgotPassword,
                          style: TwonDSTextStyles.labelHighlight(context),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
              const SizedBox(height: 24),
              
              authState.isLoading 
                ? const CircularProgressIndicator(color: TwonDSColors.accentMoon)
                : TwonDSElevatedButton(
                    text: isLogin ? AppStrings.loginAction : AppStrings.registerAction, 
                    onPressed: () {
                      final controller = ref.read(authControllerProvider.notifier);

                      if (isLogin) {
                        controller.login(emailController.text, passwordController.text);
                      } else {
                        controller.signUp(emailController.text, passwordController.text, nameController.text);
                      }
                    }
                  ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  setState(() {
                    emailController.clear();
                    passwordController.clear();
                    nameController.clear();
                    ref.read(authControllerProvider.notifier).resetState();
                    isLogin = !isLogin;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.padded, 
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text.rich(
                    TextSpan(
                      text: isLogin ? AppStrings.noAccount : AppStrings.alreadyHaveAccount,
                      style: TwonDSTextStyles.bodySmall(context),
                      children: [
                        TextSpan(
                          text: isLogin ? AppStrings.registerAction : AppStrings.loginAction,
                          style: TwonDSTextStyles.labelHighlight(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildDivider(context),
              _googleButton(ref, authState.isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtleColor = colorScheme.onSurface.withValues(alpha: isDark ? 0.24 : 0.15);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: subtleColor, 
              thickness: 1
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "o", 
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              )
            ),
          ),
          Expanded(
            child: Divider(
              color: subtleColor, 
              thickness: 1
            )
          ),
        ],
      ),
    );
  }

  Widget _googleButton(WidgetRef ref, bool isLoading) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: isLoading 
          ? null 
          : () => ref.read(authControllerProvider.notifier).loginWithGoogle(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(
          color: isDark 
              ? Colors.white24 
              : colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark ? Colors.transparent : colorScheme.surface,
      ),
      icon: Image.network(
        TwonDSAssets.googleLogoUrl,
        height: 20,
      ),
      label: Text(
        AppStrings.googleContinue,
        style: TextStyle(
          color: colorScheme.onSurface, 
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}