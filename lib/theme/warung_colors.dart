import 'package:flutter/material.dart';

class WC {
  // === BACKGROUNDS ===
  static const Color bg = Color(0xFF121215);        // Deep dark gray/black (#121215)
  static const Color bgWarm = Color(0xFF1A1A1E);    // Dark surface
  static const Color surface = Color(0x1DFFFFFF);   // Translucent glass white (11.5% opacity)
  static const Color surfaceAlt = Color(0x0CFFFFFF); // Fainter translucent

  // === PRIMARY (Neon Pink) ===
  static const Color primary = Color(0xFFFF007F);      // Neon Pink
  static const Color primaryLight = Color(0x29FF007F); // 16% opacity pink
  static const Color primaryMid = Color(0xFFFF3399);   // Mid pink

  // === ACCENT (Neon Cyan) ===
  static const Color accent = Color(0xFF00FFFF);      // Neon Cyan
  static const Color accentLight = Color(0x2900FFFF); // 16% opacity cyan

  // === SECONDARY (Neon Purple) ===
  static const Color secondary = Color(0xFF8D32FF);   // Cyber Purple
  static const Color secondaryLight = Color(0x298D32FF); // 16% opacity purple

  // === SUCCESS / WARNING / DANGER ===
  static const Color success = Color(0xFF39FF14);     // Neon Green
  static const Color successLight = Color(0x2939FF14);
  static const Color warning = Color(0xFFFFB84C);     // Gold/Yellow
  static const Color warningLight = Color(0x29FFB84C);
  static const Color danger = Color(0xFFFF0055);

  // === TEXT ===
  static const Color textDark = Color(0xFFFFFFFF);    // Solid white for title
  static const Color textMid = Color(0xFFA6A6B8);     // Cool gray for body
  static const Color textLight = Color(0xFF626272);   // Muted grey placeholder
  static const Color textWhite = Color(0xFFFFFFFF);

  // === BORDERS & SHADOW ===
  static const Color border = Color(0x1DFFFFFF);      // 11.5% white glass border
  static const Color borderMid = Color(0x2EFFFFFF);   // 18% white glass border
  static const Color shadow = Color(0x40000000);      // High depth shadow

  // === CHARACTER COLORS (Neon Accents) ===
  static const Color tehErni = Color(0xFFFF007F);     // Neon Pink
  static const Color pakRT = Color(0xFF00FFFF);       // Neon Cyan
  static const Color hansip = Color(0xFFFF9800);      // Amber
  static const Color ustad = Color(0xFF39FF14);       // Neon Green
  static const Color abangLapak = Color(0xFFFFB84C);  // Warm yellow
  static const Color kucing = Color(0xFFD500F9);      // Hot Purple

  // Aliases for backward compat
  static const Color background = bg;
  static const Color scaffold = bg;
  static const Color card = surface;
  static const Color textPrimary = textDark;
  static const Color textSecondary = textMid;
  static const Color neutral = textLight;
}

// Keep old name as alias
typedef WarungColors = WC;
