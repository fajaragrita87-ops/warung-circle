import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';

class WarungFab extends StatelessWidget {
  final ValueChanged<String> onOptionSelected;

  const WarungFab({super.key, required this.onOptionSelected});

  static const List<Map<String, dynamic>> _options = [
    {'label': 'Titip Cerita', 'desc': 'Curhatin ke Teh Erni AI', 'character': 'Teh Erni'},
    {'label': 'Titip Skill', 'desc': 'Swap skill sama orang lain', 'character': 'Ustad'},
    {'label': 'Buka Circle', 'desc': 'Ajak ngongkrong bareng', 'character': 'Pak RT'},
    {'label': 'Buka Lapak', 'desc': 'Jualan di posko warung', 'character': 'Abang Lapak'},
  ];

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (ctx) => _WarungMenu(
            options: _options,
            onSelected: (label) {
              Navigator.pop(ctx);
              onOptionSelected(label);
            },
          ),
        );
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: WC.primary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: WC.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✏️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              'Buat Post',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarungMenu extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final ValueChanged<String> onSelected;

  const _WarungMenu({required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: WC.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Mau ngapain hari ini? 😄',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: WC.textDark,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) => _MenuItem(
                opt: opt,
                onTap: () => onSelected(opt['label'] as String),
              )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Map<String, dynamic> opt;
  final VoidCallback onTap;

  const _MenuItem({required this.opt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WC.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WC.border),
        ),
        child: Row(
          children: [
            NeonGlassPortrait(
              character: opt['character'] as String,
              size: 42,
              animate: false,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt['label'] as String,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: WC.textDark,
                    ),
                  ),
                  Text(
                    opt['desc'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: WC.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: WC.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: WC.primary, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
