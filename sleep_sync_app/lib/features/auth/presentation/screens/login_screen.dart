// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/presentation/controllers/auth_controller.dart';
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

  void _showTwonSnackBar(BuildContext context, String message, Color backgroundColor) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.timestamp != previous?.timestamp) {
        if (next.error != null) {
          _showTwonSnackBar(context, next.error!, next.background);
        }
        
        if (next.successMessage != null) {
          _showTwonSnackBar(context, next.successMessage!, next.background);
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
              const Text(
                AppStrings.title,
                style: TextStyle(
                  color: TwonColors.accentMoon, 
                  fontSize: 40, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.nights_stay, size: 80, color: TwonColors.accentMoon),
              const SizedBox(height: 32),
              Text(
                isLogin ? AppStrings.loginWelcome : AppStrings.registerTitle,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                        TwonTextField(
                          hint: AppStrings.nameHint, 
                          icon: Icons.person, 
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox(key: ValueKey('empty')),
              ),
              TwonTextField(hint: AppStrings.emailLabel, icon: Icons.email, controller: emailController),
              const SizedBox(height: 16),
              TwonTextField(hint: AppStrings.passwordLabel, icon: Icons.lock, controller: passwordController, isPassword: true),
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
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7), 
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
              const SizedBox(height: 24),
              
              authState.isLoading 
                ? const CircularProgressIndicator(color: TwonColors.accentMoon)
                : TwonButton(
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
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7), 
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: isLogin ? AppStrings.registerAction : AppStrings.loginAction,
                          style: const TextStyle(
                            color: TwonColors.accentMoon,
                            fontWeight: FontWeight.bold,
                            height: 1.9, 
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildDivider(),
              _googleButton(ref, authState.isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("o", style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
          ),
          const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
        ],
      ),
    );
  }

  Widget _googleButton(WidgetRef ref, bool isLoading) {
    return OutlinedButton.icon(
      onPressed: isLoading 
          ? null 
          : () => ref.read(authControllerProvider.notifier).loginWithGoogle(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Image.network( // O usa Image.asset si tienes el archivo
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
        height: 20,
      ),
      label: const Text(
        "Continuar con Google",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}