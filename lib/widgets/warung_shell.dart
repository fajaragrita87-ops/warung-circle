import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/bottom_nav_bar.dart';
import 'package:warung_circle/widgets/warung_fab.dart';

class WarungShell extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget body;
  final bool showFab;
  final List<Widget>? actions;

  const WarungShell({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.showFab = true,
    this.actions,
  });

  void _onTabSelected(BuildContext context, int index) {
    if (index == currentIndex) return;
    final mapping = [
      Routes.home,
      Routes.ruangTengah,
      Routes.titipCerita,
      Routes.openCircle,
      Routes.dapurErni,
    ];
    Navigator.pushReplacementNamed(context, mapping[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: WarungColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.coffee, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Warung Circle',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(title,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: WarungColors.background,
        actions: actions,
        elevation: 0,
      ),
      backgroundColor: WarungColors.background,
      body: SafeArea(child: body),
      floatingActionButton: showFab
          ? WarungFab(
              onOptionSelected: (option) {
                switch (option) {
                  case 'Titip Cerita':
                    Navigator.pushNamed(context, Routes.titipCerita);
                    break;
                  case 'Titip Skill':
                    Navigator.pushNamed(context, Routes.ruangTengah);
                    break;
                  case 'Buka Circle':
                    Navigator.pushNamed(context, Routes.openCircle);
                    break;
                  case 'Buka Lapak':
                    Navigator.pushNamed(context, Routes.lapak);
                    break;
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: (index) => _onTabSelected(context, index),
      ),
    );
  }
}
