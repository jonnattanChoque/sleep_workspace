import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TwonDSColors.background,
      colorScheme: const ColorScheme.dark(
        primary: TwonDSColors.accentMoon,
        surface: TwonDSColors.surface,
        onSurface: Colors.white,
        error: TwonDSColors.error,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: TwonDSColors.primaryNight,
        surface: Colors.white,
        onSurface: TwonDSColors.background,
        error: TwonDSColors.error,
      ),
    );
  }
}