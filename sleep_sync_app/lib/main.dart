import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/provider/loader_provider.dart';
import 'package:sleep_sync_app/core/provider/theme_provider.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';
import 'package:sleep_sync_app/core/utils/enum_lottie.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_wrapper.dart';
import 'firebase_options.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';
import 'package:intl/date_symbol_data_local.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final bool? isDark = await storage.getThemeMode();

  final initialTheme = isDark == null 
      ? ThemeMode.system 
      : (isDark ? ThemeMode.dark : ThemeMode.light);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('es_ES', null);
  
  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => initialTheme),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaderState = ref.watch(loaderProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isThemeLoading = ref.watch(themeLoadingProvider);
    
    return MaterialApp(
      key: ValueKey(themeMode), 
      title: AppStrings.title,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: TwonDSTheme.light,
      darkTheme: TwonDSTheme.dark,
      builder: (context, child) {
        return AnimatedTheme(
          data: themeMode == ThemeMode.dark ? TwonDSTheme.dark : TwonDSTheme.light,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: child!,
        );
      },
      home: Stack(
        children: [
          const AuthWrapper(),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isThemeLoading || loaderState.isLoading
                  ? TwnDSOverlayLoader(
                      key: const ValueKey('theme_loader'),
                      lottiePath: StateLottie.loading.path,
                      message: loaderState.message ?? AppStrings.changeTheme,
                    )
                  : const SizedBox.shrink(),
            ),
          )
        ],
      )
    );
  }
}