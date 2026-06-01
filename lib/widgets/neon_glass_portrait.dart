import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';

/// Portrait karakter bergaya cute card — soft background, rounded, emoji besar
class NeonGlassPortrait extends StatelessWidget {
  final String character;
  final double size;
  final bool animate; // kept for backward compat, ignored
  final bool showLabel;

  const NeonGlassPortrait({
    super.key,
    required this.character,
    this.size = 56,
    this.animate = true,
    this.showLabel = false,
  });

  Map<String, dynamic> _getConfig() {
    switch (character) {
      case 'Teh Erni':
        return {'emoji': '🍵', 'color': WC.tehErni, 'bg': const Color(0xFFFFECEF)};
      case 'Pak RT':
        return {'emoji': '👮', 'color': WC.pakRT, 'bg': const Color(0xFFE8F1FF)};
      case 'Hansip':
        return {'emoji': '🚨', 'color': WC.hansip, 'bg': const Color(0xFFFFF3E0)};
      case 'Ustad':
        return {'emoji': '🕌', 'color': WC.ustad, 'bg': const Color(0xFFE8F8EF)};
      case 'Abang Lapak':
        return {'emoji': '🏪', 'color': WC.abangLapak, 'bg': const Color(0xFFFFFBE6)};
      case 'Kucing':
      case 'Kucing Warung':
        return {'emoji': '🐱', 'color': WC.kucing, 'bg': const Color(0xFFF5E8FF)};
      default:
        return {'emoji': '☕', 'color': WC.primary, 'bg': WC.primaryLight};
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _getConfig();
    final Color glowColor = cfg['color'] as Color;
    final String emoji = cfg['emoji'] as String;
    final Color bgColor = cfg['bg'] as Color;

    final portrait = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: glowColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.18),
            blurRadius: size * 0.3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.52, height: 1.0),
        ),
      ),
    );

    if (!showLabel) return portrait;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        portrait,
        const SizedBox(height: 6),
        Text(
          character,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: WC.textMid,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
