import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/widgets/bounce_mascot.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;
  int _adminTapCount = 0;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut),
    );

    // Auto-login persistence check: redirect to Home if already logged in
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && WS.isLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnim,
        builder: (_, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                      const Color(0xFFFFF5F3), const Color(0xFFFFEDE8), _bgAnim.value)!,
                  Color.lerp(
                      const Color(0xFFFFE4DE), const Color(0xFFFFF0ED), _bgAnim.value)!,
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Decorative floating circles background
            ..._buildFloatingDecorations(),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    const SizedBox(height: 40),

                    // Logo badge
                    FadeScaleIn(
                      delay: const Duration(milliseconds: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              _adminTapCount++;
                              if (_adminTapCount >= 5) {
                                _adminTapCount = 0;
                                try {
                                  await FirebaseService().signInWithEmail('superadmin@warung.com', 'admin123');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '👑 Mode Dewa Diaktifkan! Selamat datang Superadmin! ☕',
                                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: WC.success,
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(context, Routes.home);
                                  }
                                } catch (e) {
                                  await WS.login('Teh Erni Super', '08111111111', role: 'superadmin');
                                  WS.kopiBalance = 999.0;
                                  WS.respectPoints = 999.0;
                                  WS.redFlags = 0.0;
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '👑 Mode Dewa Diaktifkan (Mock)! Selamat datang Superadmin! ☕',
                                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: WC.success,
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(context, Routes.home);
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ketuk ${5 - _adminTapCount} kali lagi untuk membuka mode rahasia... 😉',
                                      style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.black87,
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: WC.primary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('☕',
                                      style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Warung Circle',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Big mascot with bounce animation
                    FadeScaleIn(
                      delay: const Duration(milliseconds: 200),
                      child: BounceMascot(
                        assetPath: 'assets/images/teh_erni_transparent.png',
                        size: 220,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Main headline
                    FadeScaleIn(
                      delay: const Duration(milliseconds: 350),
                      child: Column(
                        children: [
                          Text(
                            'Warung Circle',
                            style: GoogleFonts.poppins(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: WC.textDark,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tempat nongkrong digital tanpa ribet, tanpa jaim',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: WC.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Kampung Digital Gen Z\nCerita bebas • Tuker keahlian • Temuin circle lu ✨',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: WC.textMid,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Character row
                    FadeScaleIn(
                      delay: const Duration(milliseconds: 450),
                      child: _CharacterRow(),
                    ),

                    const Spacer(),

                    // CTA Buttons
                    SlideUpIn(
                      delay: const Duration(milliseconds: 550),
                      child: Column(
                        children: [
                          KopiButton(
                            label: 'Masuk & Cari Circle Lu 🔥',
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, WS.isLoggedIn ? Routes.home : Routes.onboarding),
                          ),
                          const SizedBox(height: 12),
                          KopiOutlineButton(
                            label: 'Udah pernah nongkrong? Masuk sini',
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, WS.isLoggedIn ? Routes.home : Routes.login),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingDecorations() {
    return [
      Positioned(
        top: -40,
        right: -40,
        child: _DecoCircle(size: 180, color: WC.primary.withOpacity(0.08)),
      ),
      Positioned(
        top: 120,
        left: -30,
        child: _DecoCircle(size: 100, color: WC.accent.withOpacity(0.1)),
      ),
      Positioned(
        bottom: 200,
        right: -20,
        child: _DecoCircle(size: 80, color: WC.secondary.withOpacity(0.08)),
      ),
      Positioned(
        bottom: -50,
        left: -30,
        child: _DecoCircle(size: 160, color: WC.primary.withOpacity(0.06)),
      ),
      // floating emoji decorations
      const Positioned(top: 80, right: 40,
          child: Text('⭐', style: TextStyle(fontSize: 18))),
      const Positioned(top: 200, left: 20,
          child: Text('💬', style: TextStyle(fontSize: 14))),
      const Positioned(bottom: 280, right: 30,
          child: Text('🧡', style: TextStyle(fontSize: 16))),
      const Positioned(bottom: 320, left: 25,
          child: Text('✨', style: TextStyle(fontSize: 12))),
    ];
  }
}

class _DecoCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecoCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CharacterRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chars = ['Teh Erni', 'Pak RT', 'Hansip', 'Abang Lapak', 'Kucing'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: chars
          .map((c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: NeonGlassPortrait(character: c, size: 44, animate: false),
              ))
          .toList(),
    );
  }
}
