import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class WarungTheme {
  static ThemeData themeData(BuildContext context) {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: WarungColors.background,
      canvasColor: WarungColors.background,
      primaryColor: WarungColors.primary,
      splashColor: WarungColors.primary.withAlpha(31),
      colorScheme: ColorScheme.fromSeed(
        seedColor: WarungColors.primary,
        primary: WarungColors.primary,
        secondary: WarungColors.secondary,
        surface: WarungColors.card,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: WarungColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: WarungColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: WarungColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: WarungColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: WarungColors.textPrimary,
          fontSize: 14,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: WarungColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: WarungColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WarungColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 4,
          shadowColor: WarungColors.primary.withAlpha(51),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WarungColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: WarungColors.primary.withOpacity(0.3), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: WarungColors.primary.withOpacity(0.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WarungColors.primary, width: 2.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: WarungColors.textPrimary.withAlpha(153),
        ),
      ),
      cardTheme: CardThemeData(
        color: WarungColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        shadowColor: WarungColors.primary.withAlpha(38),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: WarungColors.card,
        selectedItemColor: WarungColors.primary,
        unselectedItemColor: WarungColors.neutral,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
    );
  }
}
