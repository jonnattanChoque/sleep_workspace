import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/auth/presentation/screens/login_screen.dart';
import 'package:sleep_sync_app/features/auth/presentation/screens/verification_pending_screen.dart';
import 'package:sleep_sync_app/features/link/presentation/screens/dashboard_screen.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {

  static const platform = MethodChannel('com.example.sleep_sync_app/actions');
  
  @override
  void initState() {
    super.initState();
    initDeepLinkListener();

    platform.setMethodCallHandler((call) async {
      if (call.method == "onActionReceived") {
        final String link = call.arguments;
        final uri = Uri.parse(link);
        _processAction(uri.queryParameters['action']);
      }
    });
  }

  void initDeepLinkListener() {
    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen((uri) {
      debugPrint('Link capturado en Stream (Background -> Foreground): $uri');
      _processAction(uri.queryParameters['action']);
    });

    appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        debugPrint('Link inicial capturado: $uri');
        _processAction(uri.queryParameters['action']);
      }
    });
  }

  void _processAction(String? action) {
    if (action == 'logout') {
      // El delay de 300-500ms es vital. 
      // Le da tiempo a la UI de pasar de "pausada" a "activa"
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ref.read(externalLogoutRequestProvider.notifier).state = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          if (!(user.verifiedEmail ?? false)) {
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