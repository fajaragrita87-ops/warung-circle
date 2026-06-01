import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

// ============================================================
// FEATURE 2: GOSIP WARUNG — AI Satirical News Feed 📢
// Feed berita AI yang lucu & satiris tentang aktivitas warga
// ============================================================

class GosipWarungScreen extends StatefulWidget {
  const GosipWarungScreen({super.key});

  @override
  State<GosipWarungScreen> createState() => _GosipWarungScreenState();
}

class _GosipWarungScreenState extends State<GosipWarungScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _gosipFeed = [];
  int _refreshCount = 0;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // === MOCK AI HEADLINE GENERATORS ===
  // Tiga bank data dikombinasikan secara dinamis untuk menghasilkan variasi tak terbatas
  static const _subjects = [
    'Teh Erni', 'Pak RT', 'Bang Dika', 'Mba Sari', 'Warga RT 03',
    'Ustad Fahmi', 'Anon Warung 👻', 'Si Budi', 'Penghuni Blok B',
  ];

  static const _predicates = [
    'baru aja like foto mantan jam 2 pagi',
    'ketauan nonton drakor di jam kerja',
    'skip kajian gara-gara mabar ML',
    'makan 5 porsi bakso sekaligus',
    'ghosting 3 orang sekaligus di circle',
    'unfollow semua kontak abis kena bata',
    'order GoFood tengah malam 3x berturut-turut',
    'nangis gara-gara kalah debat di Meja Warung',
    'tiba-tiba DM mantan setelah 2 tahun',
    'stalking profil siapa pukul 11 malam',
    'posting meme tentang diri sendiri tanpa sadar',
    'jual saldo Kopi buat bayar bakso',
  ];

  static const _reactions = [
    '😂😂😂', '👀 Gossip Alert!', '🔥 HOT!', '😱 Astaga!',
    '☕ Spill!', '💅 Duh!', '🤣 WKWK', '😤 Masyaallah',
  ];

  static const _categories = [
    {'label': '🔥 BREAKING', 'color': 0xFFE8453C},
    {'label': '👀 EKSKLUSIF', 'color': 0xFF5B8DEF},
    {'label': '☕ HOT TEA', 'color': 0xFFFF8C69},
    {'label': '💅 DRAMA', 'color': 0xFFAB47BC},
    {'label': '🎯 UPDATE', 'color': 0xFF4CAF7D},
  ];

  static const _characters = ['Teh Erni', 'Pak RT', 'Abang Lapak', 'Ustad', 'Kucing'];
  static const _timestamps = [
    'Baru aja • 1 mnt',
    '5 mnt yang lalu',
    '12 mnt yang lalu',
    'Setengah jam lalu',
    '1 jam yang lalu',
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _fetchGossip(initial: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  // === LOGIC: Mock "AI" gossip generation ===
  Future<void> _fetchGossip({bool initial = false}) async {
    setState(() => _isLoading = true);
    _refreshCount++;

    // Simulate network delay
    await Future.delayed(Duration(milliseconds: initial ? 800 : 1500));

    if (!mounted) return;

    final rng = Random();
    final count = initial ? 5 : 3;
    final newGossips = List.generate(count, (i) {
      final subject = _subjects[rng.nextInt(_subjects.length)];
      final predicate = _predicates[rng.nextInt(_predicates.length)];
      final reaction = _reactions[rng.nextInt(_reactions.length)];
      final category = _categories[rng.nextInt(_categories.length)];
      final character = _characters[rng.nextInt(_characters.length)];
      final timestamp = _timestamps[rng.nextInt(_timestamps.length)];
      final likes = rng.nextInt(450) + 10;
      final comments = rng.nextInt(80) + 2;

      return {
        'headline': '$subject $predicate',
        'reaction': reaction,
        'category': category,
        'character': character,
        'timestamp': timestamp,
        'likes': likes,
        'comments': comments,
        'id': '$_refreshCount-$i',
      };
    });

    setState(() {
      if (initial) {
        _gosipFeed.clear();
      }
      _gosipFeed.insertAll(0, newGossips);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '📢 Gosip Warung',
      currentIndex: 0,
      showFab: false,
      actions: [
        ScaleButton(
          onTap: _isLoading ? null : () => _fetchGossip(),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: WC.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: WC.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
          ),
        ),
      ],
      body: Column(
        children: [
          // === LIVE HEADER ===
          _buildLiveHeader(),

          // === GOSSIP FEED ===
          Expanded(
            child: _isLoading && _gosipFeed.isEmpty
                ? _buildSkeleton()
                : RefreshIndicator(
                    color: WC.primary,
                    onRefresh: () => _fetchGossip(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: _gosipFeed.length,
                      itemBuilder: (ctx, i) => FadeScaleIn(
                        key: ValueKey(_gosipFeed[i]['id']),
                        delay: Duration(milliseconds: min(i * 80, 400)),
                        child: _GosipCard(gossip: _gosipFeed[i]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [WC.primary.withOpacity(0.08), WC.accent.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WC.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (ctx, child) => Transform.scale(scale: _pulseAnim.value, child: child),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: WC.danger, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'LIVE — Gosip Warung AI',
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: WC.danger),
          ),
          const Spacer(),
          Text(
            '${_gosipFeed.length} berita hari ini',
            style: GoogleFonts.nunito(fontSize: 10, color: WC.textMid),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (ctx, i) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 120,
        decoration: BoxDecoration(
          color: WC.surface,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _GosipCard extends StatefulWidget {
  final Map<String, dynamic> gossip;
  const _GosipCard({required this.gossip, super.key});

  @override
  State<_GosipCard> createState() => _GosipCardState();
}

class _GosipCardState extends State<_GosipCard> {
  bool _isLiked = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.gossip['likes'] as int;
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.gossip;
    final categoryMap = g['category'] as Map<String, dynamic>;
    final categoryColor = Color(categoryMap['color'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Row(
              children: [
                NeonGlassPortrait(character: g['character'] as String, size: 36, animate: false),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gosip Warung AI 🤖',
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.textDark)),
                    Text(g['timestamp'] as String,
                        style: GoogleFonts.nunito(fontSize: 10, color: WC.textLight)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.12), borderRadius: BorderRadius.circular(100)),
                  child: Text(categoryMap['label'] as String,
                      style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: categoryColor)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // === HEADLINE ===
            Text(
              '${g['reaction']} ${g['headline']}',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: WC.textDark, height: 1.4),
            ),

            const SizedBox(height: 14),

            // === FOOTER ACTIONS ===
            Row(
              children: [
                ScaleButton(
                  onTap: () => setState(() {
                    _isLiked = !_isLiked;
                    _likes += _isLiked ? 1 : -1;
                  }),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: _isLiked ? WC.danger : WC.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text('$_likes',
                          style: GoogleFonts.poppins(
                              fontSize: 11, fontWeight: FontWeight.w700,
                              color: _isLiked ? WC.danger : WC.textLight)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: WC.textLight),
                    const SizedBox(width: 4),
                    Text('${g['comments']}',
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: WC.textLight)),
                  ],
                ),
                const Spacer(),
                ScaleButton(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: WC.primaryLight, borderRadius: BorderRadius.circular(100)),
                    child: Text('Sebarkan ☕',
                        style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: WC.primary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
