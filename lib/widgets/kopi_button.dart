import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/scale_button.dart';

/// Tombol utama Warung Circle — coral red pill dengan shadow lembut
class KopiButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;
  final Color? color;
  final Color? textColor;
  final double height;
  final IconData? icon;

  const KopiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.color,
    this.textColor,
    this.height = 54,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? WC.primary;
    final fg = textColor ?? Colors.white;

    final content = Container(
      height: height,
      width: fullWidth ? double.infinity : null,
      padding: fullWidth ? null : const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              color: fg,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    return ScaleButton(
      onTap: onPressed,
      child: content,
    );
  }
}

/// Tombol outline — putih dengan border coral
class KopiOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;
  final Color? borderColor;

  const KopiOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bc = borderColor ?? WC.primary;
    return ScaleButton(
      onTap: onPressed,
      child: Container(
        height: 54,
        width: fullWidth ? double.infinity : null,
        padding: fullWidth ? null : const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: WC.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: bc, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: bc,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
