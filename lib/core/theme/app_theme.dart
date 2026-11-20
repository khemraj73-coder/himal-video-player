import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(Color accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfaceLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLightElevated,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.2),
        inactiveTrackColor: Colors.grey.shade300,
      ),
      iconTheme: const IconThemeData(color: AppColors.textLight),
      textTheme: _textTheme(AppColors.textLight, AppColors.textLightSecondary),
    );
  }

  static ThemeData dark(Color accent) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDarkElevated,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.2),
        inactiveTrackColor: Colors.white24,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDark),
      textTheme: _textTheme(AppColors.textDark, AppColors.textDarkSecondary),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(color: primary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: primary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: primary, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: primary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: primary, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: primary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: primary),
      titleSmall: TextStyle(color: secondary),
      bodyLarge: TextStyle(color: primary),
      bodyMedium: TextStyle(color: primary),
      bodySmall: TextStyle(color: secondary),
      labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: secondary),
      labelSmall: TextStyle(color: secondary),
    );
  }
}