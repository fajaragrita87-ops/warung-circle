import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class KopiButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const KopiButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: WarungColors.primary,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
