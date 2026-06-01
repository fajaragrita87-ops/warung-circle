import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/cute_card.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: CuteCard(
        borderRadius: 28,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: WarungColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(tag,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: WarungColors.primary)),
                ),
                const Spacer(),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: WarungColors.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.rocket_launch,
                      color: WarungColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: WarungColors.textSecondary)),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.favorite, color: WarungColors.danger, size: 20),
                const SizedBox(width: 8),
                Text('$reactionCount',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Icon(Icons.comment,
                    color: WarungColors.textSecondary, size: 20),
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
