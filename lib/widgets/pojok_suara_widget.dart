import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';

// ============================================================
// WIDGET: POJOKAN SUARA — Audio Chat Room Floater 🎙️
//
// Dipasang sebagai overlay icon di dalam OpenCircleScreen.
// Tap icon mic → modal daftar anggota online → "Ajak Ngobrol"
// ============================================================

/// Floating microphone button to embed in a circle screen
class PojokSuaraButton extends StatelessWidget {
  const PojokSuaraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: () => _showPojokSuaraModal(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF2D2D4E)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF88).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.mic_rounded,
            color: Color(0xFF00FF88),
            size: 22,
          ),
        ),
      ),
    );
  }

  static void _showPojokSuaraModal(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _PojokSuaraModal(),
    );
  }
}

// === INTERNAL MODAL WIDGET ===
class _PojokSuaraModal extends StatefulWidget {
  const _PojokSuaraModal();

  @override
  State<_PojokSuaraModal> createState() => _PojokSuaraModalState();
}

class _PojokSuaraModalState extends State<_PojokSuaraModal>
    with TickerProviderStateMixin {
  // Ongoing audio call state
  String? _callingUser;
  bool _inCall = false;
  int _callSeconds = 0;
  Timer? _callTimer;

  // Speaking animation
  late AnimationController _micPulse;
  late Animation<double> _micScale;

  // Mock online members of this Circle
  static const _onlineMembers = [
    {
      'name': 'Teh Erni',
      'character': 'Teh Erni',
      'status': 'Lagi Nyantai ☕',
      'statusColor': 0xFF00FF88,
      'isInCall': false,
    },
    {
      'name': 'Kak Budi (Pak RT)',
      'character': 'Pak RT',
      'status': 'Baru Absen 🏠',
      'statusColor': 0xFF5B8DEF,
      'isInCall': false,
    },
    {
      'name': 'Bang Dika',
      'character': 'Abang Lapak',
      'status': 'Lagi Mager 🛋️',
      'statusColor': 0xFFFFB84C,
      'isInCall': false,
    },
    {
      'name': 'Mba Sari',
      'character': 'Teh Erni',
      'status': 'Di Jalan 🚗',
      'statusColor': 0xFFAB47BC,
      'isInCall': false,
    },
    {
      'name': 'Ustad Fahmi',
      'character': 'Ustad',
      'status': 'Nyiapin Kajian 📖',
      'statusColor': 0xFF4CAF7D,
      'isInCall': false,
    },
    {
      'name': 'Nita Warung',
      'character': 'Kucing',
      'status': 'Sambil Masak 🍳',
      'statusColor': 0xFFFF8C69,
      'isInCall': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _micPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _micScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _micPulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _micPulse.dispose();
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatCallTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _startCall(String memberName) {
    HapticFeedback.mediumImpact();
    setState(() {
      _callingUser = memberName;
      _inCall = false;
      _callSeconds = 0;
    });

    // Simulate 2-second "ringing" then connect
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _inCall = true);
      _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _callSeconds++);
      });
    });
  }

  void _endCall() {
    HapticFeedback.heavyImpact();
    _callTimer?.cancel();
    setState(() {
      _callingUser = null;
      _inCall = false;
      _callSeconds = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A1A2E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            const Text('📞', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              'Obrolan suara selesai. Kapan-kapan ngobrol lagi ya! 👋',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 14),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // === ACTIVE CALL BANNER ===
          if (_callingUser != null) _buildActiveCallBanner(),

          // === HEADER ===
          _buildHeader(),

          // === ROOM MEMBERS LIST ===
          Flexible(
            child: _buildMemberList(),
          ),

          // === CREATE ROOM BUTTON ===
          _buildCreateRoomButton(),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildActiveCallBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _inCall
              ? [const Color(0xFF00CC6A), const Color(0xFF00AA55)]
              : [const Color(0xFFE8453C), const Color(0xFFCC3333)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_inCall ? const Color(0xFF00FF88) : WC.danger).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated mic icon
          AnimatedBuilder(
            animation: _micScale,
            builder: (ctx, child) => Transform.scale(
              scale: _inCall ? _micScale.value : 1.0,
              child: child,
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _inCall ? Icons.mic_rounded : Icons.phone_in_talk_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _inCall ? 'Ngobrol sama $_callingUser' : 'Nyambungin ke $_callingUser...',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                Text(
                  _inCall ? '🟢 Connected • ${_formatCallTime(_callSeconds)}' : '📳 Ringing...',
                  style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),

          // End call button
          ScaleButton(
            onTap: _endCall,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF88).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mic_rounded, color: Color(0xFF00FF88), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pojokan Suara 🎙️',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  Text(
                    'Siapa yang mau diajak ngobrol?',
                    style: GoogleFonts.nunito(fontSize: 12, color: Colors.white38),
                  ),
                ],
              ),
              const Spacer(),
              // Live indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF88).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF88),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${_onlineMembers.length} Online',
                      style: GoogleFonts.poppins(
                          fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF00FF88)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      itemCount: _onlineMembers.length,
      itemBuilder: (ctx, i) {
        final member = _onlineMembers[i];
        final isCurrentCall = _callingUser == member['name'];
        final statusColor = Color(member['statusColor'] as int);

        return FadeScaleIn(
          delay: Duration(milliseconds: i * 60),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isCurrentCall
                  ? const Color(0xFF00CC6A).withOpacity(0.12)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isCurrentCall
                    ? const Color(0xFF00FF88).withOpacity(0.4)
                    : Colors.white.withOpacity(0.06),
                width: isCurrentCall ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Avatar with online dot
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NeonGlassPortrait(
                        character: member['character'] as String,
                        size: 44,
                        animate: false,
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1A1A2E), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'] as String,
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member['status'] as String,
                          style: GoogleFonts.nunito(
                              fontSize: 11, color: statusColor.withOpacity(0.8), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  // Invite button or In-call badge
                  if (isCurrentCall)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF88).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _micScale,
                            builder: (ctx, child) => Transform.scale(
                              scale: _inCall ? _micScale.value : 1.0,
                              child: child,
                            ),
                            child: const Icon(Icons.mic_rounded, size: 12, color: Color(0xFF00FF88)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _inCall ? 'Ngobrol' : 'Nyambung...',
                            style: GoogleFonts.poppins(
                                fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF00FF88)),
                          ),
                        ],
                      ),
                    )
                  else
                    ScaleButton(
                      onTap: _callingUser == null
                          ? () => _startCall(member['name'] as String)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _callingUser != null
                              ? Colors.white.withOpacity(0.04)
                              : const Color(0xFF00FF88),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: _callingUser == null
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF00FF88).withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 12,
                              color: _callingUser != null
                                  ? Colors.white24
                                  : const Color(0xFF1A1A2E),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ajak Ngobrol',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: _callingUser != null
                                    ? Colors.white24
                                    : const Color(0xFF1A1A2E),
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
        );
      },
    );
  }

  Widget _buildCreateRoomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: ScaleButton(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1A1A2E),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Row(
                children: [
                  const Text('🎙️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    'Ruang Suara dibuat! Warga Circle bisa join sekarang 🔥',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D2D4E), Color(0xFF3D3D5E)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline_rounded, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text(
                'Buat Ruang Suara Sendiri',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
