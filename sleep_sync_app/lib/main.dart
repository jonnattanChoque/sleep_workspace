// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final storage = StorageService();
  final bool? isDark = await storage.getThemeMode();

  final initialTheme = isDark == null 
      ? ThemeMode.system 
      : (isDark ? ThemeMode.dark : ThemeMode.light);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('es_ES', null);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Zumbidos de Sueño',
    description: 'Este canal se usa para los zumbidos de tu pareja.',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FlutterNativeSplash.remove();
  
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
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final effectiveTheme = switch (themeMode) {
      ThemeMode.dark => TwonDSTheme.dark,
      ThemeMode.light => TwonDSTheme.light,
      ThemeMode.system => platformBrightness == Brightness.dark 
          ? TwonDSTheme.dark 
          : TwonDSTheme.light,
    };
    
    return MaterialApp(
      key: ValueKey(themeMode), 
      title: AppStrings.title,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: TwonDSTheme.light,
      darkTheme: TwonDSTheme.dark,
      localizationsDelegates: const [
        // Estos tres son los "traductores" por defecto de Flutter
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // <--- ESTE es el que traduce el Picker
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (por si acaso)
      ],
      builder: (context, child) {
        return AnimatedTheme(
          data: effectiveTheme,
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