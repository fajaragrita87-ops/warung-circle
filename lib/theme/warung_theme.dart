import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class WarungTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: WC.bg,
      canvasColor: WC.bg,
      primaryColor: WC.primary,
      splashColor: WC.primary.withOpacity(0.08),
      highlightColor: WC.primary.withOpacity(0.04),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: WC.primary,
        onPrimary: Colors.white,
        secondary: WC.accent,
        onSecondary: Colors.white,
        error: WC.danger,
        onError: Colors.white,
        surface: WC.surface,
        onSurface: WC.textDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
            fontSize: 32, fontWeight: FontWeight.w900, color: WC.textDark),
        displayMedium: GoogleFonts.poppins(
            fontSize: 26, fontWeight: FontWeight.w800, color: WC.textDark),
        titleLarge: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.w800, color: WC.textDark),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w700, color: WC.textDark),
        titleSmall: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: WC.textDark),
        bodyLarge: GoogleFonts.nunito(
            fontSize: 15, fontWeight: FontWeight.w600, color: WC.textMid),
        bodyMedium: GoogleFonts.nunito(
            fontSize: 13, fontWeight: FontWeight.w500, color: WC.textMid),
        bodySmall: GoogleFonts.nunito(
            fontSize: 11, fontWeight: FontWeight.w500, color: WC.textLight),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: WC.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: WC.textDark, size: 22),
        titleTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: WC.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WC.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WC.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WC.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WC.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WC.primary, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(
          color: WC.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: WC.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: WC.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: WC.primaryLight,
        selectedColor: WC.primary,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: WC.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: WC.surface,
        selectedItemColor: WC.primary,
        unselectedItemColor: WC.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(
        color: WC.border,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: WC.textDark,
        contentTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Keep old signature for compatibility
  static ThemeData themeData(BuildContext context) => theme;
}
