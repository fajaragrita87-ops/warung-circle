import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/kopi_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarungColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WarungColors.background,
        title: const Text('Onboarding Teh Erni'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo bro! Aku Teh Erni.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Nanti kamu akan dapat 50 Kopi gratis dan badge Anak Baru. Jawab 4 pertanyaan cepat dulu ya!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ...['Mood Santai', 'Mood Serius', 'Mood Emosional', 'Mood Ambisius']
                .map(
                  (mood) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: WarungColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WarungColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: WarungColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              mood,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const Spacer(),
            KopiButton(
              label: 'Selesaikan Onboarding',
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
