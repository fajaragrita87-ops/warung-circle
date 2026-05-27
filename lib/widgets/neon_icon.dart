import 'package:flutter/material.dart';

class NeonIcon extends StatelessWidget {
  final String label;
  final Color color;

  const NeonIcon({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withAlpha(143), color.withAlpha(41)],
          radius: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(64),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label.substring(0, 1),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
    );
  }
}
