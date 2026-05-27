import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomNavItem(icon: Icons.home, label: 'Posko'),
      _BottomNavItem(icon: Icons.chair, label: 'Ruang'),
      _BottomNavItem(icon: Icons.book, label: 'Cerita'),
      _BottomNavItem(icon: Icons.group, label: 'Circle'),
      _BottomNavItem(icon: Icons.restaurant, label: 'Dapur'),
    ];

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: WarungColors.card,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: WarungColors.primary.withAlpha(36),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final selected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon,
                        color: selected
                            ? WarungColors.primary
                            : WarungColors.neutral),
                    const SizedBox(height: 6),
                    Text(item.label,
                        style: TextStyle(
                          color: selected
                              ? WarungColors.primary
                              : WarungColors.neutral,
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final String label;

  const _BottomNavItem({required this.icon, required this.label});
}
