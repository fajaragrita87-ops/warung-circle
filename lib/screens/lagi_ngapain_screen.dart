import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

// ============================================================
// FITUR: LAGI NGAPAIN? — Chunky Camera Moment Capture 📸
//
// Flow:
// 1. Layar utama: 1 tombol raksasa "FOTO SEKARANG" berkedip neon
// 2. Tap → overlay hitam + countdown 60 detik
// 3. Simulasi foto → muncul input "Lagi ngapain nih?"
// 4. Post → konfeti meledak di layar!
// ============================================================

class LagiNgapainScreen extends StatefulWidget {
  const LagiNgapainScreen({super.key});

  @override
  State<LagiNgapainScreen> createState() => _LagiNgapainScreenState();
}

class _LagiNgapainScreenState extends State<LagiNgapainScreen>
    with TickerProviderStateMixin {
  // === STATE ===
  _LagiNgapainPhase _phase = _LagiNgapainPhase.idle;
  int _secondsLeft = 60;
  Timer? _countdownTimer;
  final TextEditingController _captionCtrl = TextEditingController();
  bool _showConfetti = false;

  // Animasi untuk tombol raksasa (neon pulsing)
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseScale;
  late Animation<double> _glowOpacity;

  // Animasi shake setelah foto diambil
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  // Animasi zoom in untuk "foto" placeholder
  late AnimationController _photoCtrl;
  late Animation<double> _photoScale;

  // Daftar contoh foto aktivitas (emoji placeholder)
  static const _mockActivities = [
    {'emoji': '☕', 'bg': Color(0xFF3D2B1F), 'label': 'Ngopi dulu bro'},
    {'emoji': '🎮', 'bg': Color(0xFF1A1A3E), 'label': 'Mabar bareng squad'},
    {'emoji': '📚', 'bg': Color(0xFF1F3D2B), 'label': 'Belajar dikit lah'},
    {'emoji': '🍜', 'bg': Color(0xFF3D1F1F), 'label': 'Makan dulu bestie'},
    {'emoji': '😴', 'bg': Color(0xFF1A2A3D), 'label': 'Tidur siang bentar'},
    {'emoji': '🚗', 'bg': Color(0xFF2B1F3D), 'label': 'Di jalan macet bro'},
  ];
  late Map<String, dynamic> _mockPhoto;

  // Confetti particles
  final List<_ConfettiDot> _confetti = [];

  @override
  void initState() {
    super.initState();
    _mockPhoto = _mockActivities[Random().nextInt(_mockActivities.length)];

    // Neon pulse animation for the big button
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Shake animation
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));

    // Photo reveal animation
    _photoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _photoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _photoCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseCtrl.dispose();
    _shakeCtrl.dispose();
    _photoCtrl.dispose();
    _captionCtrl.dispose();
    super.dispose();
  }

  // === STEP 1: Start countdown + simulate camera ===
  void _startCamera() {
    HapticFeedback.heavyImpact(); // Haptic buzz on tap!
    _mockPhoto = _mockActivities[Random().nextInt(_mockActivities.length)];
    setState(() {
      _phase = _LagiNgapainPhase.countdown;
      _secondsLeft = 60;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        _capturePhoto();
      }
    });
  }

  // === STEP 2: Simulate shutter + photo capture ===
  void _capturePhoto() {
    HapticFeedback.mediumImpact();
    _shakeCtrl.forward(from: 0);
    setState(() => _phase = _LagiNgapainPhase.captured);
    _photoCtrl.forward(from: 0);
  }

  // === STEP 3: Post + confetti explosion ===
  void _postMoment() {
    HapticFeedback.lightImpact();
    final caption = _captionCtrl.text.trim().isEmpty
        ? _mockPhoto['label'] as String
        : _captionCtrl.text.trim();

    // Generate confetti particles
    final rng = Random();
    setState(() {
      _showConfetti = true;
      _confetti.clear();
      for (int i = 0; i < 60; i++) {
        _confetti.add(_ConfettiDot(
          x: rng.nextDouble(),
          y: rng.nextDouble() * 0.6,
          color: [
            const Color(0xFFFF00FF), // Neon pink
            const Color(0xFF00FF88), // Neon green
            const Color(0xFF00FFFF), // Cyan
            WC.warning,
            WC.primary,
          ][i % 5],
          size: rng.nextDouble() * 10 + 5,
          rotation: rng.nextDouble() * 3.14,
        ));
      }
      _phase = _LagiNgapainPhase.posted;
    });

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF00FF88),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '"$caption" udah di-post ke Meja Warung!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );

    // Auto dismiss confetti
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
          _phase = _LagiNgapainPhase.idle;
          _captionCtrl.clear();
        });
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _LagiNgapainPhase.idle;
      _secondsLeft = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '📸 Lagi Ngapain?',
      currentIndex: 0,
      showFab: false,
      body: Stack(
        children: [
          // === MAIN CONTENT ===
          _buildContent(),

          // === COUNTDOWN OVERLAY ===
          if (_phase == _LagiNgapainPhase.countdown)
            _buildCountdownOverlay(),

          // === CONFETTI LAYER ===
          if (_showConfetti)
            IgnorePointer(
              child: CustomPaint(
                painter: _ConfettiPainter(dots: _confetti),
                child: const SizedBox.expand(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return switch (_phase) {
      _LagiNgapainPhase.idle => _buildIdleScreen(),
      _LagiNgapainPhase.countdown => _buildIdleScreen(), // Behind overlay
      _LagiNgapainPhase.captured => _buildCapturedScreen(),
      _LagiNgapainPhase.posted => _buildPostedScreen(),
    };
  }

  // === IDLE: Giant chunky neon button ===
  Widget _buildIdleScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF5F3), Color(0xFFFFFDFB)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === TOP TEXT ===
              FadeScaleIn(
                child: Column(
                  children: [
                    Text(
                      'Lagi Ngapain Sih? 👀',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: WC.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ambil foto apa adanya,\nno filter, no edit, jujur aja! 😂',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: WC.textMid,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // === CHUNKY NEON BUTTON ===
              FadeScaleIn(
                delay: const Duration(milliseconds: 150),
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (ctx, child) => Transform.scale(
                    scale: _pulseScale.value,
                    child: child,
                  ),
                  child: ScaleButton(
                    scale: 0.92,
                    onTap: _startCamera,
                    child: AnimatedBuilder(
                      animation: _glowOpacity,
                      builder: (ctx, child) => Container(
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF00FF), Color(0xFFCC00CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF00FF).withOpacity(_glowOpacity.value),
                              blurRadius: 40,
                              spreadRadius: 4,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: const Color(0xFFFF00FF).withOpacity(0.3),
                              blurRadius: 80,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'FOTO SEKARANG',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // === RECENT MOMENT STRIP ===
              FadeScaleIn(
                delay: const Duration(milliseconds: 300),
                child: _buildRecentStrip(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Warga lagi ngapain 👀',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: WC.textMid),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 72,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _mockActivities.length,
            itemBuilder: (ctx, i) {
              final act = _mockActivities[i];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                width: 64,
                decoration: BoxDecoration(
                  color: act['bg'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(act['emoji'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 2),
                    Text(
                      (act['label'] as String).split(' ').first,
                      style: GoogleFonts.nunito(fontSize: 8, color: Colors.white54, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // === COUNTDOWN OVERLAY (dark + timer) ===
  Widget _buildCountdownOverlay() {
    final progress = _secondsLeft / 60;
    final isUrgent = _secondsLeft <= 10;

    return Positioned.fill(
      child: GestureDetector(
        onTap: () {}, // block taps
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: const Color(0xE61A1A2E),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Close button
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ScaleButton(
                      onTap: _cancelCountdown,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Timer circle
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (ctx, child) => Transform.scale(
                    scale: isUrgent ? (0.98 + _pulseCtrl.value * 0.04) : 1.0,
                    child: child,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isUrgent ? const Color(0xFFFF0055) : const Color(0xFF00FF88),
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$_secondsLeft',
                            style: GoogleFonts.poppins(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: isUrgent ? const Color(0xFFFF0055) : const Color(0xFF00FF88),
                            ),
                          ),
                          Text(
                            'detik tersisa',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white54,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  'Ambil foto apa adanya\ndalam 2 menit... 📸',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'Jujur, no filter, no drama!',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white38,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 48),

                // Simulate shutter button
                ScaleButton(
                  scale: 0.88,
                  onTap: _capturePhoto,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Tap untuk jepret! 📸',
                  style: GoogleFonts.nunito(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === CAPTURED: Show photo placeholder + caption input ===
  Widget _buildCapturedScreen() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _shakeAnim,
          builder: (ctx, child) => Transform.translate(
            offset: Offset(_shakeAnim.value, 0),
            child: child,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Flash effect header
                  Row(
                    children: [
                      ScaleButton(
                        onTap: () => setState(() => _phase = _LagiNgapainPhase.idle),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '📸 Foto Diambil!',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Photo placeholder (dark card with big emoji)
                  AnimatedBuilder(
                    animation: _photoScale,
                    builder: (ctx, child) => Transform.scale(scale: _photoScale.value, child: child),
                    child: Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: _mockPhoto['bg'] as Color,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF00FF).withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _mockPhoto['emoji'] as String,
                            style: const TextStyle(fontSize: 80),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              '📍 Warung Circle • Baru aja',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: Colors.white54, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Caption input
                  Text(
                    'Lagi ngapain nih? 🤔',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _captionCtrl,
                    autofocus: true,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: _mockPhoto['label'] as String,
                      hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFFF00FF), width: 2),
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('✍️', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // POST button (neon green)
                  ScaleButton(
                    scale: 0.92,
                    onTap: _postMoment,
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00FF88), Color(0xFF00CC6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00FF88).withOpacity(0.5),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, color: Color(0xFF1A1A2E), size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'POST KE WARUNG! 🔥',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1A1A2E),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === POSTED: Success confetti screen ===
  Widget _buildPostedScreen() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: FadeScaleIn(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                'Udah di-post, Bestie!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Warga warung sekarang tau\nlo lagi ngapain 👀',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ScaleButton(
                onTap: () => setState(() {
                  _phase = _LagiNgapainPhase.idle;
                  _captionCtrl.clear();
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF00FF),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF00FF).withOpacity(0.4),
                        blurRadius: 24,
                      )
                    ],
                  ),
                  child: Text(
                    'Upload Lagi 📸',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === PHASE ENUM ===
enum _LagiNgapainPhase { idle, countdown, captured, posted }

// === CONFETTI DATA ===
class _ConfettiDot {
  final double x, y, size, rotation;
  final Color color;
  _ConfettiDot({required this.x, required this.y, required this.size, required this.color, required this.rotation});
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiDot> dots;
  _ConfettiPainter({required this.dots});

  @override
  void paint(Canvas canvas, Size size) {
    for (final d in dots) {
      final paint = Paint()..color = d.color.withOpacity(0.85);
      canvas.save();
      canvas.translate(d.x * size.width, d.y * size.height);
      canvas.rotate(d.rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: d.size, height: d.size * 0.4),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
