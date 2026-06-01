import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

// ============================================================
// FEATURE 5: SCAN WARUNG — O2O QR Scanner Integration 📷
// Simulasi scan QR kode di warung fisik, dapet reward Kopi
// ============================================================

class ScanWarungScreen extends StatefulWidget {
  final int initialKopiBalance;
  const ScanWarungScreen({super.key, this.initialKopiBalance = 40});

  @override
  State<ScanWarungScreen> createState() => _ScanWarungScreenState();
}

class _ScanWarungScreenState extends State<ScanWarungScreen>
    with TickerProviderStateMixin {
  // === STATE MANAGEMENT ===
  int _kopiBalance;
  bool _isScanning = false;
  bool _scanSuccess = false;
  String _scanMessage = '';
  String _rewardEmoji = '';
  int _rewardAmount = 0;

  late AnimationController _scanLineCtrl;
  late Animation<double> _scanLineAnim;
  late AnimationController _successCtrl;
  late Animation<double> _successAnim;

  // Mock warung QR database
  static const _warungDatabase = [
    {'name': 'Warkop Pak Bejo', 'reward': 10, 'bonus': 'Kopi Gratis', 'emoji': '☕'},
    {'name': 'Bakso Cak Min', 'reward': 8, 'bonus': 'Diskon 20%', 'emoji': '🍜'},
    {'name': 'Warteg Bu Sari', 'reward': 12, 'bonus': 'Nasi Gratis', 'emoji': '🍛'},
    {'name': 'Es Teh Jumbo', 'reward': 5, 'bonus': 'Es Teh Gratis', 'emoji': '🧋'},
    {'name': 'Gorengan Pak Udin', 'reward': 7, 'bonus': 'Tahu Gratis', 'emoji': '🥙'},
  ];

  final List<Map<String, dynamic>> _scanHistory = [];

  _ScanWarungScreenState() : _kopiBalance = 0;

  @override
  void initState() {
    super.initState();
    _kopiBalance = widget.initialKopiBalance;

    // Scan line animation (loops up and down)
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut),
    );

    // Success pop animation
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  // === LOGIC: Simulate QR scan & reward ===
  Future<void> _handleScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _scanSuccess = false;
    });

    // Simulate camera scanning delay
    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    // Randomly pick a warung from the mock database
    final warung = _warungDatabase[Random().nextInt(_warungDatabase.length)];
    final reward = warung['reward'] as int;

    setState(() {
      _isScanning = false;
      _scanSuccess = true;
      _kopiBalance += reward;
      _rewardAmount = reward;
      _rewardEmoji = warung['emoji'] as String;
      _scanMessage =
          'Selamat! ${warung['bonus']} di ${warung['name']} 🎉\n+$reward Kopi masuk dompet lo!';
      _scanHistory.insert(0, {
        ...warung,
        'timestamp': _formatTime(DateTime.now()),
        'kopiEarned': reward,
      });
    });

    _successCtrl.forward(from: 0);

    // Auto-hide success after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _scanSuccess = false);
    });
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '📷 Scan Warung',
      currentIndex: 0,
      showFab: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          children: [
            // === KOPI BALANCE HEADER ===
            FadeScaleIn(child: _buildBalanceHeader()),
            const SizedBox(height: 20),

            // === SCAN VIEWFINDER ===
            FadeScaleIn(
              delay: const Duration(milliseconds: 100),
              child: _buildScanViewfinder(),
            ),
            const SizedBox(height: 20),

            // === SUCCESS OVERLAY ===
            if (_scanSuccess) _buildSuccessCard(),

            // === SCAN BUTTON ===
            FadeScaleIn(
              delay: const Duration(milliseconds: 200),
              child: KopiButton(
                label: _isScanning ? '🔍 Scanning QR...' : 'Scan QR Warung 📷',
                onPressed: _handleScan,
                color: _isScanning ? WC.textLight : WC.primary,
              ),
            ),

            const SizedBox(height: 24),

            // === HOW TO USE ===
            FadeScaleIn(
              delay: const Duration(milliseconds: 250),
              child: _buildHowTo(),
            ),

            // === SCAN HISTORY ===
            if (_scanHistory.isNotEmpty) ...[
              const SizedBox(height: 20),
              FadeScaleIn(
                delay: const Duration(milliseconds: 300),
                child: _buildScanHistory(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [WC.primary.withOpacity(0.12), WC.accent.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Text('☕', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dompet Kopi', style: GoogleFonts.nunito(fontSize: 11, color: WC.textMid)),
              Text('$_kopiBalance Kopi',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900, color: WC.textDark)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: WC.successLight,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: WC.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner_rounded, size: 14, color: WC.success),
                const SizedBox(width: 4),
                Text('Scan & Earn!',
                    style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: WC.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanViewfinder() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.primary.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(color: WC.primary.withOpacity(0.15), blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dark background with grid effect
            CustomPaint(
              size: const Size(double.infinity, 260),
              painter: _GridPainter(),
            ),

            // QR Frame corners
            ..._buildQrCorners(),

            // Scanning animation line
            if (_isScanning)
              AnimatedBuilder(
                animation: _scanLineAnim,
                builder: (ctx, _) => Positioned(
                  top: 40 + _scanLineAnim.value * 160,
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, WC.primary, Colors.transparent],
                      ),
                      boxShadow: [BoxShadow(color: WC.primary, blurRadius: 8)],
                    ),
                  ),
                ),
              ),

            // Center icon / status
            if (!_isScanning)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: WC.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: WC.primary.withOpacity(0.4)),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Arahkan kamera ke QR\ndi warung langganan lo! 📷',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

            if (_isScanning)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: WC.primary, strokeWidth: 3),
                  const SizedBox(height: 16),
                  Text(
                    'Scanning QR Warung...',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white70),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQrCorners() {
    const size = 24.0;
    const thick = 3.0;
    final color = WC.primary;
    return [
      Positioned(top: 20, left: 20, child: _Corner(size: size, thick: thick, color: color, top: true, left: true)),
      Positioned(top: 20, right: 20, child: _Corner(size: size, thick: thick, color: color, top: true, left: false)),
      Positioned(bottom: 20, left: 20, child: _Corner(size: size, thick: thick, color: color, top: false, left: true)),
      Positioned(bottom: 20, right: 20, child: _Corner(size: size, thick: thick, color: color, top: false, left: false)),
    ];
  }

  Widget _buildSuccessCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
        animation: _successAnim,
        builder: (ctx, child) => Transform.scale(scale: _successAnim.value, child: child),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WC.successLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WC.success.withOpacity(0.4), width: 2),
            boxShadow: [BoxShadow(color: WC.success.withOpacity(0.2), blurRadius: 16)],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_rewardEmoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scan Berhasil! 🎉',
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: WC.success)),
                        Text(_scanMessage,
                            style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: WC.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('☕', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '+$_rewardAmount Kopi ditambahkan ke dompet!',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: WC.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowTo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cara Main Scan Warung 📖',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: WC.textDark)),
          const SizedBox(height: 12),
          ...const [
            ['1️⃣', 'Pergi ke warung langganan lo (Warkop, Bakso, dll)'],
            ['2️⃣', 'Cari stiker QR Warung Circle di kasir/meja'],
            ['3️⃣', 'Tap tombol "Scan" dan arahkan ke QR'],
            ['4️⃣', 'Kopi langsung masuk ke dompet lo!'],
          ].map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step[0], style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(step[1],
                          style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildScanHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Scan 📋',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: WC.textDark)),
        const SizedBox(height: 10),
        ..._scanHistory.map((s) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: WC.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: WC.border)),
              child: Row(
                children: [
                  Text(s['emoji'] as String, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('${s['name']} • ${s['bonus']}',
                        style: GoogleFonts.nunito(fontSize: 12, color: WC.textDark, fontWeight: FontWeight.w700)),
                  ),
                  Text(s['timestamp'] as String,
                      style: GoogleFonts.nunito(fontSize: 10, color: WC.textLight)),
                  const SizedBox(width: 8),
                  Text('+${s['kopiEarned']} ☕',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: WC.success)),
                ],
              ),
            )),
      ],
    );
  }
}

// === QR Corner Indicator Widget ===
class _Corner extends StatelessWidget {
  final double size;
  final double thick;
  final Color color;
  final bool top;
  final bool left;

  const _Corner({
    required this.size,
    required this.thick,
    required this.color,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(thick: thick, color: color, top: top, left: left),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final double thick;
  final Color color;
  final bool top;
  final bool left;

  _CornerPainter({required this.thick, required this.color, required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final hDir = left ? size.width : -size.width;
    final vDir = top ? size.height : -size.height;

    canvas.drawLine(Offset(x, y), Offset(x + hDir * 0.7, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + vDir * 0.7), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 0.5;

    const spacing = 20.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
