import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/scale_button.dart';

// ============================================================
// BOTTOM NAV BAR v2 — 4 Tab Clean Design
// Posko | Pasar | Obrolan | Profil
// ============================================================
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const _items = [
    {'icon': Icons.home_rounded, 'label': 'Posko', 'route': Routes.home},
    {'icon': Icons.storefront_rounded, 'label': 'Pasar', 'route': Routes.lapak},
    {'icon': Icons.chat_bubble_rounded, 'label': 'Obrolan', 'route': Routes.chat},
    {'icon': Icons.person_rounded, 'label': 'Profil', 'route': Routes.dapurErni},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: WC.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _items.length,
          (i) => _NavItem(
            icon: _items[i]['icon'] as IconData,
            label: _items[i]['label'] as String,
            isActive: i == currentIndex,
            onTap: () => onTabSelected(i),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: onTap,
      child: SizedBox(
        height: 52, // Minimum 44px tap target
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          padding: EdgeInsets.symmetric(
            horizontal: isActive ? 18 : 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isActive ? WC.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : WC.textLight,
                size: 22,
              ),
              if (isActive) ...[
                const SizedBox(width: 7),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
