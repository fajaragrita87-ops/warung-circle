import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

// ============================================================
// FEATURE 3: LELANG WAKTU — Time Auction for Skill Swap ⏰
// Warga bisa tawar waktu & skill, counter-offer, countdown timer
// ============================================================

class LelangWaktuScreen extends StatefulWidget {
  const LelangWaktuScreen({super.key});

  @override
  State<LelangWaktuScreen> createState() => _LelangWaktuScreenState();
}

class _LelangWaktuScreenState extends State<LelangWaktuScreen> {
  // === STATE ===
  final TextEditingController _skillCtrl = TextEditingController();
  final TextEditingController _counterCtrl = TextEditingController();

  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  String _selectedDuration = '30 menit';

  // Auction listing state
  final List<Map<String, dynamic>> _auctions = [];

  // Active bid countdown
  Timer? _countdownTimer;
  int _countdownSeconds = 0;

  static const _durations = ['15 menit', '30 menit', '1 jam', '2 jam'];

  static const List<Map<String, dynamic>> _mockAuctions = [
    {
      'id': 'a1',
      'offerer': 'Dika Pratama',
      'character': 'Abang Lapak',
      'skill': 'Edit Video Cinematic',
      'time': '14:00',
      'duration': '1 jam',
      'counterOffer': 'Traktir Bakso Cak Min',
      'status': 'pending',
      'secondsLeft': 540,
    },
    {
      'id': 'a2',
      'offerer': 'Mba Sari',
      'character': 'Teh Erni',
      'skill': 'Public Speaking Coaching',
      'time': '10:00',
      'duration': '30 menit',
      'counterOffer': null,
      'status': 'open',
      'secondsLeft': 0,
    },
    {
      'id': 'a3',
      'offerer': 'Ustad Fahmi',
      'character': 'Ustad',
      'skill': 'Belajar Ngaji Online',
      'time': '19:30',
      'duration': '45 menit',
      'counterOffer': 'Bantu Desain Spanduk Masjid',
      'status': 'accepted',
      'secondsLeft': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _auctions.addAll(_mockAuctions.map((a) => Map<String, dynamic>.from(a)));
    _startCountdowns();
  }

  void _startCountdowns() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        for (final a in _auctions) {
          if (a['status'] == 'pending' && a['secondsLeft'] > 0) {
            a['secondsLeft'] = (a['secondsLeft'] as int) - 1;
            if (a['secondsLeft'] == 0) {
              a['status'] = 'expired';
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _skillCtrl.dispose();
    _counterCtrl.dispose();
    super.dispose();
  }

  String _formatCountdown(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted': return WC.success;
      case 'pending': return WC.warning;
      case 'expired': return WC.textLight;
      default: return WC.secondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted': return '✅ Accepted';
      case 'pending': return '⏳ Menunggu';
      case 'expired': return '⌛ Expired';
      default: return '🟢 Open';
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: WC.primary,
            onPrimary: Colors.white,
            surface: WC.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _postAuction() {
    final skill = _skillCtrl.text.trim();
    if (skill.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi dulu skill yang mau kamu tawarkan!')),
      );
      return;
    }

    setState(() {
      _auctions.insert(0, {
        'id': 'u${DateTime.now().millisecond}',
        'offerer': (WS.isLoggedIn && WS.userName.isNotEmpty) ? WS.userName : 'Kamu',
        'character': 'Teh Erni',
        'skill': skill,
        'time': _selectedTime.format(context),
        'duration': _selectedDuration,
        'counterOffer': null,
        'status': 'open',
        'secondsLeft': 0,
      });
    });

    _skillCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: WC.success,
        content: Text('Penawaran lo udah diposting! Tunggu tawaran balik ya! ⏰',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  void _showCounterOffer(Map<String, dynamic> auction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: WC.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: WC.border, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Tawar Balas ⚡',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w900, color: WC.textDark)),
              const SizedBox(height: 6),
              Text(
                '${auction['offerer']} menawarkan "${auction['skill']}" jam ${auction['time']}',
                style: GoogleFonts.nunito(fontSize: 13, color: WC.textMid),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _counterCtrl,
                decoration: const InputDecoration(
                  hintText: 'Misal: Traktir Kopi, Buat Desain, Masak Nasi Goreng...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('💬', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              KopiButton(
                label: 'Kirim Tawar Balas! ⚡',
                onPressed: () {
                  final counter = _counterCtrl.text.trim();
                  if (counter.isEmpty) return;
                  setState(() {
                    final idx = _auctions.indexWhere((a) => a['id'] == auction['id']);
                    if (idx >= 0) {
                      _auctions[idx]['counterOffer'] = counter;
                      _auctions[idx]['status'] = 'pending';
                      _auctions[idx]['secondsLeft'] = 600; // 10 minutes
                    }
                  });
                  _counterCtrl.clear();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: WC.warning,
                      content: Text('Tawar balas terkirim! Menunggu konfirmasi... ⏳',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '⏰ Lelang Waktu',
      currentIndex: 1,
      showFab: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // === HEADER ===
          FadeScaleIn(child: _buildHeader()),
          const SizedBox(height: 16),

          // === POST AUCTION FORM ===
          FadeScaleIn(
            delay: const Duration(milliseconds: 100),
            child: _buildPostForm(),
          ),
          const SizedBox(height: 20),

          // === ACTIVE AUCTIONS ===
          Text('Lelang Aktif di Warung 🔥',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: WC.textDark)),
          const SizedBox(height: 12),

          ..._auctions.asMap().entries.map((entry) => FadeScaleIn(
                delay: Duration(milliseconds: 150 + entry.key * 80),
                child: _AuctionCard(
                  auction: entry.value,
                  onCounter: () => _showCounterOffer(entry.value),
                  onAccept: () {
                    setState(() {
                      entry.value['status'] = 'accepted';
                      WS.kopiBalance += 5.0; // Bonus +5 Kopi riil!
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: WC.success,
                        content: Text('Deal! Skill swap terjadi! Bonus +5 Kopi! ✅',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    );
                  },
                  formatCountdown: _formatCountdown,
                  statusColor: _statusColor,
                  statusLabel: _statusLabel,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [WC.warning.withOpacity(0.15), WC.accent.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('⏰', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lelang Waktu',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w900, color: WC.textDark)),
                Text('Tawarkan skill lo, tentukan waktu, tawar-menawar!',
                    style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tawarkan Skill Lo 🎯',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: WC.textDark)),
          const SizedBox(height: 14),
          TextField(
            controller: _skillCtrl,
            decoration: const InputDecoration(
              hintText: 'Skill apa yang mau lo tawarkan?',
              prefixIcon: Padding(padding: EdgeInsets.all(14), child: Text('🎓', style: TextStyle(fontSize: 16))),
            ),
          ),
          const SizedBox(height: 12),

          // Time Picker
          ScaleButton(
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: WC.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: WC.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 18, color: WC.textMid),
                  const SizedBox(width: 10),
                  Text(
                    'Jam ${_selectedTime.format(context)}',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: WC.textDark),
                  ),
                  const Spacer(),
                  Text('Ubah Waktu',
                      style: GoogleFonts.nunito(fontSize: 11, color: WC.primary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Duration Picker
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _durations.length,
              itemBuilder: (ctx, i) {
                final isSelected = _durations[i] == _selectedDuration;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ScaleButton(
                    onTap: () => setState(() => _selectedDuration = _durations[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? WC.warning : WC.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: isSelected ? Colors.transparent : WC.border),
                      ),
                      child: Text(
                        _durations[i],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : WC.textMid,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          KopiButton(label: 'Mulai Lelang! ⚡', onPressed: _postAuction, color: WC.warning),
        ],
      ),
    );
  }
}

class _AuctionCard extends StatelessWidget {
  final Map<String, dynamic> auction;
  final VoidCallback onCounter;
  final VoidCallback onAccept;
  final String Function(int) formatCountdown;
  final Color Function(String) statusColor;
  final String Function(String) statusLabel;

  const _AuctionCard({
    required this.auction,
    required this.onCounter,
    required this.onAccept,
    required this.formatCountdown,
    required this.statusColor,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final status = auction['status'] as String;
    final hasCounter = auction['counterOffer'] != null;
    final secondsLeft = auction['secondsLeft'] as int;
    final sColor = statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status == 'accepted' ? WC.success.withOpacity(0.4) : WC.border,
          width: status == 'accepted' ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === TOP ROW ===
            Row(
              children: [
                NeonGlassPortrait(character: auction['character'] as String, size: 40, animate: false),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auction['offerer'] as String,
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: WC.textDark)),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 10, color: WC.textLight),
                          const SizedBox(width: 4),
                          Text('Jam ${auction['time']} • ${auction['duration']}',
                              style: GoogleFonts.nunito(fontSize: 10, color: WC.textLight)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: sColor.withOpacity(0.12), borderRadius: BorderRadius.circular(100)),
                  child: Text(statusLabel(status),
                      style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: sColor)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // === SKILL ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: WC.secondaryLight, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 14, color: WC.secondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(auction['skill'] as String,
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: WC.secondary)),
                  ),
                ],
              ),
            ),

            // === COUNTER OFFER ===
            if (hasCounter) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: WC.warningLight, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz_rounded, size: 14, color: WC.warning),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Tawar Balik: "${auction['counterOffer']}"',
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.warning)),
                    ),
                  ],
                ),
              ),
            ],

            // === COUNTDOWN ===
            if (status == 'pending' && secondsLeft > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: WC.danger.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WC.danger.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_rounded, size: 14, color: WC.danger),
                    const SizedBox(width: 6),
                    Text(
                      'Menunggu Konfirmasi — Sisa ${formatCountdown(secondsLeft)}',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: WC.danger),
                    ),
                  ],
                ),
              ),
            ],

            // === ACTION BUTTONS ===
            if (status == 'open' || status == 'pending') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (status == 'open')
                    Expanded(
                      child: ScaleButton(
                        onTap: onCounter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: WC.primaryLight,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text('Tawar Balas ⚡',
                                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.primary)),
                          ),
                        ),
                      ),
                    ),
                  if (status == 'open') const SizedBox(width: 8),
                  Expanded(
                    child: ScaleButton(
                      onTap: onAccept,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: WC.success,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [BoxShadow(color: WC.success.withOpacity(0.3), blurRadius: 8)],
                        ),
                        child: Center(
                          child: Text('Accept Deal ✅',
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (status == 'accepted')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text('🎉 Skill Swap berhasil terjadi! Bonus +5 Kopi masuk dompet!',
                      style: GoogleFonts.nunito(fontSize: 11, color: WC.success, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
