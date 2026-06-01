import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'emoji': '☕',
      'color': WC.primary,
      'bg': WC.primaryLight,
      'title': 'Selamat Datang\ndi Warung Circle!',
      'subtitle': 'Tempat nongkrong digital Gen Z. Curhat, ketawa, dan connect sama orang-orang seru sekitar lo!',
      'character': '🍵',
    },
    {
      'emoji': '🔄',
      'color': WC.secondary,
      'bg': WC.secondaryLight,
      'title': 'Skill Swap\ndi Ruang Tengah',
      'subtitle': 'Punya skill tapi mau belajar hal baru? Tuker aja! Ngajar coding, dapet pelajaran masak. Fair banget!',
      'character': '📚',
    },
    {
      'emoji': '🏪',
      'color': WC.accent,
      'bg': WC.accentLight,
      'title': 'Lapak & Circle\nSemua Ada!',
      'subtitle': 'Jualan di Lapak, ikut aktivitas bareng di OpenCircle, atau curhat ke Teh Erni AI yang sassy! Lengkap abis.',
      'character': '🛍️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WC.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 20, 0),
                child: TextButton(
                  onPressed: _goToHome,
                  child: Text(
                    'Lewatin',
                    style: GoogleFonts.poppins(
                      color: WC.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (ctx, i) => _SlidePage(slide: _slides[i]),
              ),
            ),

            // Dots + Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? WC.primary : WC.border,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  KopiButton(
                    label: _currentPage == _slides.length - 1
                        ? 'Mulai Nongkrong! 🔥'
                        : 'Lanjut →',
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageCtrl.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      } else {
                        _goToHome();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHome() =>
      Navigator.pushReplacementNamed(context, WS.isLoggedIn ? Routes.home : Routes.login);
}

class _SlidePage extends StatelessWidget {
  final Map<String, dynamic> slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    final Color color = slide['color'] as Color;
    final Color bg = slide['bg'] as Color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Mascot speech bubble (Teh Erni greeting) for first slide
          if (slide['emoji'] == '☕') ...[
            FadeScaleIn(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: WC.primaryLight,
                  borderRadius: BorderRadius.circular(20).copyWith(
                    bottomLeft: const Radius.circular(0),
                  ),
                  border: Border.all(color: WC.primary.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: WC.primary.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🍵', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      'Hai! Gw temenin lu di sini ya 😊',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: WC.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Illustration circle
          FadeScaleIn(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  slide['character'] as String,
                  style: const TextStyle(fontSize: 90),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          FadeScaleIn(
            delay: const Duration(milliseconds: 150),
            child: Text(
              slide['title'] as String,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: WC.textDark,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          FadeScaleIn(
            delay: const Duration(milliseconds: 250),
            child: Text(
              slide['subtitle'] as String,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: WC.textMid,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
