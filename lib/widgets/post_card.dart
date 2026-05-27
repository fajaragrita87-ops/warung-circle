import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final int reactionCount;

  const PostCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.reactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [WarungColors.card, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: WarungColors.primary.withAlpha(31),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: WarungColors.secondary.withAlpha(36),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(tag,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: WarungColors.secondary)),
                ),
                const Spacer(),
                const Icon(Icons.rocket_launch, color: WarungColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.favorite,
                    color: WarungColors.accent, size: 20),
                const SizedBox(width: 8),
                Text('$reactionCount',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                const Icon(Icons.comment,
                    color: WarungColors.textPrimary, size: 20),
                const SizedBox(width: 6),
                Text('Reply', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
