import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class CuteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double borderRadius;
  final BorderSide? border;

  const CuteCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius = 24.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? WC.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.fromBorderSide(
          border ?? const BorderSide(color: WC.border, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: WC.shadow.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
