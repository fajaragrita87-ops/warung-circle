import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/kopi_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarungColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'WARUNG CIRCLE',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: WarungColors.primary,
                          fontSize: 32,
                        ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Kampung Digital Gen Z — Curhat, Tuker Skill, Cari Genk',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: WarungColors.card,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: WarungColors.primary.withAlpha(46),
                          blurRadius: 28,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Neon Glass Portrait Character',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: WarungColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              KopiButton(
                label: 'Masuk Warung 🔥',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.onboarding);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
