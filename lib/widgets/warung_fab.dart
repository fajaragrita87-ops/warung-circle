import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';

class WarungFab extends StatelessWidget {
  final ValueChanged<String> onOptionSelected;

  const WarungFab({
    super.key,
    required this.onOptionSelected,
  });

  static const Map<String, IconData> _optionIcons = {
    'Titip Cerita': Icons.auto_stories,
    'Titip Skill': Icons.handshake,
    'Buka Circle': Icons.groups,
    'Buka Lapak': Icons.storefront,
  };

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: WarungColors.primary,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: WarungColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _optionButton('Titip Cerita'),
                  _optionButton('Titip Skill'),
                  _optionButton('Buka Circle'),
                  _optionButton('Buka Lapak'),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _optionButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          onOptionSelected(label);
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: WarungColors.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(_optionIcons[label] ?? Icons.flash_on, color: Colors.white),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
