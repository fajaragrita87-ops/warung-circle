import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class RuangTengahScreen extends StatefulWidget {
  const RuangTengahScreen({super.key});

  @override
  State<RuangTengahScreen> createState() => _RuangTengahScreenState();
}

class _RuangTengahScreenState extends State<RuangTengahScreen> {
  final TextEditingController _mySkillCtrl = TextEditingController();
  final TextEditingController _wantSkillCtrl = TextEditingController();
  bool _searching = false;
  Map<String, dynamic>? _matchedPartner;

  final List<Map<String, dynamic>> _mockPartners = [
    {'name': 'Dika Pratama', 'character': 'Ustad', 'canTeach': 'Design Figma', 'wantsLearn': 'Coding Python', 'rating': 4.8, 'swaps': 12},
    {'name': 'Aulia Rahman', 'character': 'Abang Lapak', 'canTeach': 'Marketing Digital', 'wantsLearn': 'Video Editing', 'rating': 4.6, 'swaps': 8},
    {'name': 'Budi Santoso', 'character': 'Pak RT', 'canTeach': 'Public Speaking', 'wantsLearn': 'Design Logo', 'rating': 5.0, 'swaps': 23},
  ];

  final List<Map<String, dynamic>> _popularSwaps = [
    {'from': 'Coding', 'to': 'Design', 'count': 45},
    {'from': 'Masak', 'to': 'Bahasa Inggris', 'count': 32},
    {'from': 'Musik', 'to': 'Fotografi', 'count': 28},
    {'from': 'Marketing', 'to': 'Video Editing', 'count': 21},
  ];

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '🔄 Skill Swap',
      currentIndex: 1,
      showFab: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // Header
          FadeScaleIn(
            child: _SectionHeader(
              title: 'Ruang Tengah',
              subtitle: 'Tuker skill lo sama orang lain, gratis! 🔄',
              emoji: '🔄',
              color: WC.secondary,
            ),
          ),

          const SizedBox(height: 20),

          // Skill input card
          FadeScaleIn(
            delay: const Duration(milliseconds: 100),
            child: _buildInputCard(),
          ),

          const SizedBox(height: 20),

          // Match result
          if (_matchedPartner != null) ...[
            FadeScaleIn(child: _buildMatchResult()),
            const SizedBox(height: 20),
          ],

          // Popular swaps
          FadeScaleIn(
            delay: const Duration(milliseconds: 200),
            child: _buildPopularSwaps(),
          ),

          const SizedBox(height: 20),

          // Available partners
          FadeScaleIn(
            delay: const Duration(milliseconds: 300),
            child: _buildPartnerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cari Partner Swap 🎯', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: WC.textDark)),
          const SizedBox(height: 16),

          _InputField(
            ctrl: _mySkillCtrl,
            hint: 'Skill lo (misal: Coding, Design, Masak)',
            emoji: '🎓',
            label: 'Skill Gue',
            headerRight: ScaleButton(
              onTap: _searching ? null : _aiSuggestMySkill,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [WC.primary, WC.secondary],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: WC.primary.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Text(
                      'AI Suggest',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _InputField(ctrl: _wantSkillCtrl, hint: 'Skill yang mau lo pelajari', emoji: '🎯', label: 'Mau Belajar'),

          const SizedBox(height: 16),

          KopiButton(
            label: _searching ? '🔍 Lagi nyari...' : 'Cari Partner! 🔍',
            onPressed: _searching ? () {} : _findPartner,
            color: WC.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchResult() {
    final p = _matchedPartner!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WC.successLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('Partner Ketemu!', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: WC.success)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              NeonGlassPortrait(character: p['character'] as String, size: 54, animate: false),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: WC.textDark)),
                    Text('Bisa ngajarin: ${p['canTeach']}', style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid)),
                    Text('Mau belajar: ${p['wantsLearn']}', style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid)),
                    Row(children: [
                      const Icon(Icons.star_rounded, size: 14, color: WC.warning),
                      Text(' ${p['rating']} • ${p['swaps']} swap', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: WC.textMid)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          KopiButton(label: 'Ajak Swap! 🤝', onPressed: () {}, color: WC.success),
        ],
      ),
    );
  }

  Widget _buildPopularSwaps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Swap Populer 🔥', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: WC.textDark)),
        const SizedBox(height: 12),
        ..._popularSwaps.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: WC.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: WC.border)),
          child: Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: WC.secondaryLight, shape: BoxShape.circle), child: const Center(child: Text('🔄', style: TextStyle(fontSize: 16)))),
              const SizedBox(width: 12),
              Expanded(child: Text('${s['from']} ↔ ${s['to']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: WC.textDark))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: WC.secondaryLight, borderRadius: BorderRadius.circular(100)),
                child: Text('${s['count']}x', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.secondary)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPartnerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Partner Tersedia 👥', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 15, color: WC.textDark)),
        const SizedBox(height: 12),
        ..._mockPartners.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: WC.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: WC.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))]),
          child: Row(
            children: [
              NeonGlassPortrait(character: p['character'] as String, size: 48, animate: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: WC.textDark)),
                    Text('Ngajar: ${p['canTeach']}', style: GoogleFonts.nunito(fontSize: 11, color: WC.textMid)),
                    Text('Belajar: ${p['wantsLearn']}', style: GoogleFonts.nunito(fontSize: 11, color: WC.textMid)),
                  ],
                ),
              ),
              Column(children: [
                Row(children: [
                  const Icon(Icons.star_rounded, size: 13, color: WC.warning),
                  Text(' ${p['rating']}', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.textDark)),
                ]),
                const SizedBox(height: 6),
                ScaleButton(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: WC.primaryLight, borderRadius: BorderRadius.circular(100)),
                    child: Text('Swap', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.primary)),
                  ),
                ),
              ]),
            ],
          ),
        )),
      ],
    );
  }

  void _aiSuggestMySkill() {
    final List<String> popularSkills = [
      'Design Figma 🎨',
      'Coding Flutter 📱',
      'Public Speaking 🗣️',
      'Video Editing 🎬',
      'Copywriting ✍️',
      'Digital Marketing 📈',
      'Photography 📸',
      'Python Programming 🐍',
    ];
    
    setState(() {
      _searching = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final randomSkill = popularSkills[DateTime.now().millisecond % popularSkills.length];
      setState(() {
        _searching = false;
        _mySkillCtrl.text = randomSkill;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: WC.primary,
          content: Text('✨ Teh Erni AI nyaranin skill: "$randomSkill"! Kece abis! 🔥'),
        ),
      );
    });
  }

  void _findPartner() {
    final my = _mySkillCtrl.text.trim();
    final want = _wantSkillCtrl.text.trim();
    if (my.isEmpty || want.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi dulu skill lo dan yang mau dipelajari!')),
      );
      return;
    }
    setState(() { _searching = true; _matchedPartner = null; });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final matched = _mockPartners.firstWhere(
        (p) => p['canTeach'].toLowerCase().contains(want.toLowerCase()) || p['wantsLearn'].toLowerCase().contains(my.toLowerCase()),
        orElse: () => _mockPartners[0],
      );
      setState(() { _searching = false; _matchedPartner = matched; });
    });
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String emoji;
  final String label;
  final Widget? headerRight;
  const _InputField({required this.ctrl, required this.hint, required this.emoji, required this.label, this.headerRight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: WC.textMid)),
            if (headerRight != null) headerRight!,
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(padding: const EdgeInsets.all(14), child: Text(emoji, style: const TextStyle(fontSize: 16))),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, subtitle, emoji;
  final Color color;
  const _SectionHeader({required this.title, required this.subtitle, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 18, color: WC.textDark)),
                Text(subtitle, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: WC.textMid)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
