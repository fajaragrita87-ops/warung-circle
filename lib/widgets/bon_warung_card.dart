import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class BonWarungCard extends StatelessWidget {
  final String title;
  final int price;

  const BonWarungCard({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WarungColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WarungColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WarungColors.secondary.withAlpha(41),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_cafe, color: WarungColors.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('$price Kopi',
                    style: const TextStyle(color: WarungColors.textPrimary)),
              ],
            ),
          ),
          const Text('Beli',
              style: TextStyle(
                  color: WarungColors.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
