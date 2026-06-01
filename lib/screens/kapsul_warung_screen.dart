import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

// ============================================================
// FEATURE 1: KAPSUL WARUNG — Gacha Sticker System 🎲
// Warga bisa buka mystery box & kumpulin stiker karakter lucu
// ============================================================

class KapsulWarungScreen extends StatefulWidget {
  const KapsulWarungScreen({super.key});

  @override
  State<KapsulWarungScreen> createState() => _KapsulWarungScreenState();
}

class _KapsulWarungScreenState extends State<KapsulWarungScreen>
    with TickerProviderStateMixin {
  // === STATE MANAGEMENT ===
  int get _kapsulBalance => WS.kopiBalance ~/ 2;
  set _kapsulBalance(int val) {
    WS.kopiBalance = val * 2.0;
  }
  
  int _activeTab = 0; // 0 = Kapsul, 1 = Inventory

  // Track newly acquired stickers locally
  final Set<String> _newStickerNames = {};

  // Inventory stiker yang sudah dikumpulkan
  List<Map<String, dynamic>> get _inventory {
    final List<Map<String, dynamic>> list = [];
    for (final name in WS.gachaInventory) {
      final poolItem = _stickerPool.firstWhere((s) => s['name'] == name, orElse: () => _stickerPool[0]);
      final existingIndex = list.indexWhere((s) => s['name'] == name);
      final isNew = _newStickerNames.contains(name);
      if (existingIndex >= 0) {
        list[existingIndex]['count'] = (list[existingIndex]['count'] as int) + 1;
      } else {
        list.add({
          'emoji': poolItem['emoji'],
          'name': poolItem['name'],
          'rarity': poolItem['rarity'],
          'count': 1,
          'isNew': isNew,
        });
      }
    }
    return list;
  }

  // Confetti particles state
  bool _showConfetti = false;
  final List<_ConfettiParticle> _particles = [];

  // Animasi tiap kapsul
  late List<AnimationController> _kapsulaCtrl;
  late List<Animation<double>> _kapsulAnim;

  // Stiker pool yang bisa didapat dari gacha
  static const List<Map<String, String>> _stickerPool = [
    {'emoji': '😭', 'name': 'Teh Erni Galau', 'rarity': 'Langka'},
    {'emoji': '😡', 'name': 'Pak RT Ngamuk', 'rarity': 'Lumayan'},
    {'emoji': '🍜', 'name': 'Bakso Sultan', 'rarity': 'Biasa'},
    {'emoji': '😎', 'name': 'Abang Lapak Cool', 'rarity': 'Lumayan'},
    {'emoji': '🤲', 'name': 'Ustad Bijak', 'rarity': 'Biasa'},
    {'emoji': '🐱', 'name': 'Kucing Misterius', 'rarity': 'Legendary!'},
    {'emoji': '☕', 'name': 'Kopi Ajaib', 'rarity': 'Biasa'},
    {'emoji': '🔥', 'name': 'Hot Take Pak RT', 'rarity': 'Langka'},
    {'emoji': '💅', 'name': 'Teh Erni Bestie', 'rarity': 'Langka'},
    {'emoji': '🕌', 'name': 'Masjid Sejuk', 'rarity': 'Biasa'},
    {'emoji': '🎮', 'name': 'Mabar Legend', 'rarity': 'Lumayan'},
    {'emoji': '🥷', 'name': 'Anon Warung', 'rarity': 'Legendary!'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize 3 kapsul animation controllers
    _kapsulaCtrl = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _kapsulAnim = _kapsulaCtrl.map((ctrl) {
      return Tween<double>(begin: 1.0, end: 1.18).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.elasticOut),
      );
    }).toList();

    // Auto loop idle float animation
    for (var i = 0; i < 3; i++) {
      _startFloatLoop(i, delay: Duration(milliseconds: i * 200));
    }
  }

  void _startFloatLoop(int index, {Duration delay = Duration.zero}) async {
    await Future.delayed(delay);
    while (mounted) {
      await _kapsulaCtrl[index].forward();
      await _kapsulaCtrl[index].reverse();
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  @override
  void dispose() {
    for (var c in _kapsulaCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  // === LOGIC: Open a single capsule & add sticker to inventory ===
  Map<String, String> _openCapsule() {
    final random = Random();
    // Weighted rarity
    final roll = random.nextInt(100);
    List<Map<String, String>> pool;
    if (roll < 5) {
      pool = _stickerPool.where((s) => s['rarity'] == 'Legendary!').toList();
    } else if (roll < 25) {
      pool = _stickerPool.where((s) => s['rarity'] == 'Langka').toList();
    } else if (roll < 60) {
      pool = _stickerPool.where((s) => s['rarity'] == 'Lumayan').toList();
    } else {
      pool = _stickerPool.where((s) => s['rarity'] == 'Biasa').toList();
    }
    return pool[random.nextInt(pool.length)];
  }

  // === LOGIC: Open all 3 capsules at once ===
  void _openAll() {
    if (_kapsulBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: WC.danger,
          content: Text('Kapsul lo habis, Bestie! Top Up dulu ya! ☕',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      );
      return;
    }

    final toOpen = min(_kapsulBalance, 3);
    final newStickers = List.generate(toOpen, (_) => _openCapsule());

    setState(() {
      _kapsulBalance -= toOpen;
      for (final sticker in newStickers) {
        final name = sticker['name']!;
        _newStickerNames.add(name);
        WS.gachaInventory.add(name);
      }
      _showConfetti = true;
    });

    // Show result dialog
    _showOpenResult(newStickers);

    // Auto dismiss confetti
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  void _showOpenResult(List<Map<String, String>> stickers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: WC.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉 Yeay! Dapet Stiker!',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w900, color: WC.textDark)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: stickers
                  .map((s) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _StickerResultCard(sticker: s),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            KopiButton(
              label: 'Mantap! Simpan ke Inventory 🎒',
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _activeTab = 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'Legendary!':
        return const Color(0xFFFFB84C); // gold
      case 'Langka':
        return WC.primary;
      case 'Lumayan':
        return WC.secondary;
      default:
        return WC.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '🎲 Kapsul Warung',
      currentIndex: 0,
      showFab: false,
      body: Stack(
        children: [
          Column(
            children: [
              // === TOP BALANCE BAR ===
              _buildBalanceBar(),

              // === TAB SELECTOR ===
              _buildTabSelector(),

              // === CONTENT ===
              Expanded(
                child: _activeTab == 0 ? _buildKapsulTab() : _buildInventoryTab(),
              ),
            ],
          ),

          // === CONFETTI OVERLAY ===
          if (_showConfetti) _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildBalanceBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [WC.primary.withOpacity(0.12), WC.accent.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Text('🎲', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kapsul Warga', style: GoogleFonts.nunito(fontSize: 11, color: WC.textMid)),
              Text(
                '$_kapsulBalance Kapsul tersisa',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, color: WC.textDark),
              ),
            ],
          ),
          const Spacer(),
          ScaleButton(
            onTap: () {
              setState(() => _kapsulBalance += 3);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: WC.success,
                  content: Text('+3 Kapsul ditambahkan! Gas buka! 🎲',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: WC.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text('+ Top Up',
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _buildTab('🎲 Buka Kapsul', 0),
          const SizedBox(width: 12),
          _buildTab('🎒 Inventory (${_inventory.length})', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: ScaleButton(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? WC.primary : WC.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isActive ? Colors.transparent : WC.border),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : WC.textMid,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKapsulTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        children: [
          Text(
            'Ketuk kapsul buat liat isinya! 👀',
            style: GoogleFonts.nunito(fontSize: 14, color: WC.textMid, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // === 3 KAPSUL BOXES ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) {
              return AnimatedBuilder(
                animation: _kapsulAnim[i],
                builder: (ctx, child) => Transform.scale(
                  scale: _kapsulAnim[i].value,
                  child: child,
                ),
                child: ScaleButton(
                  onTap: _kapsulBalance > 0
                      ? () {
                          if (_kapsulBalance <= 0) return;
                          final sticker = _openCapsule();
                          setState(() {
                            _kapsulBalance--;
                            final name = sticker['name']!;
                            _newStickerNames.add(name);
                            WS.gachaInventory.add(name);
                          });
                          _showOpenResult([sticker]);
                        }
                      : () {},
                  child: _KapsulBox(index: i),
                ),
              );
            }),
          ),

          const SizedBox(height: 40),

          // === BUKA SEMUA BUTTON ===
          KopiButton(
            label: _kapsulBalance > 0
                ? 'Buka Semua Kapsul! 🎲'
                : 'Kapsul Habis — Top Up dulu!',
            onPressed: _openAll,
            color: _kapsulBalance > 0 ? WC.primary : WC.textLight,
          ),

          const SizedBox(height: 16),

          // === RARITY CHART ===
          _buildRarityInfo(),
        ],
      ),
    );
  }

  Widget _buildRarityInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tingkat Kelangkaan 📊',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: WC.textDark)),
          const SizedBox(height: 12),
          ...const [
            ['Legendary! 🌟', '5%', Color(0xFFFFB84C)],
            ['Langka 💎', '20%', WC.primary],
            ['Lumayan 🎯', '35%', WC.secondary],
            ['Biasa 📦', '40%', WC.textLight],
          ].map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: r[2] as Color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(r[0] as String,
                            style: GoogleFonts.nunito(fontSize: 12, color: WC.textMid))),
                    Text(r[1] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w700, color: r[2] as Color)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    if (_inventory.isEmpty) {
      return Center(
        child: FadeScaleIn(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎒', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('Inventory Masih Kosong!',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w800, color: WC.textDark)),
              const SizedBox(height: 8),
              Text('Buka kapsul dulu buat ngumpulin stiker kece!',
                  style: GoogleFonts.nunito(fontSize: 13, color: WC.textMid),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: KopiButton(
                  label: 'Gas Buka Kapsul! 🎲',
                  onPressed: () => setState(() => _activeTab = 0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _inventory.length,
      itemBuilder: (ctx, i) {
        final sticker = _inventory[i];
        final rarityColor = _rarityColor(sticker['rarity'] as String);
        final isNew = sticker['isNew'] == true;
        if (isNew) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _newStickerNames.remove(sticker['name']);
              });
            }
          });
        }
        return FadeScaleIn(
          delay: Duration(milliseconds: i * 50),
          child: Container(
            decoration: BoxDecoration(
              color: WC.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isNew ? rarityColor : WC.border,
                  width: isNew ? 2 : 1),
              boxShadow: isNew
                  ? [BoxShadow(color: rarityColor.withOpacity(0.25), blurRadius: 12)]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sticker['emoji'] as String, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  sticker['name'] as String,
                  style: GoogleFonts.nunito(
                      fontSize: 9, fontWeight: FontWeight.w700, color: WC.textDark),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: rarityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    sticker['rarity'] as String,
                    style: GoogleFonts.poppins(
                        fontSize: 7, fontWeight: FontWeight.w800, color: rarityColor),
                  ),
                ),
                if ((sticker['count'] as int) > 1)
                  Text('x${sticker['count']}',
                      style: GoogleFonts.poppins(
                          fontSize: 9, fontWeight: FontWeight.w700, color: WC.textLight)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfetti() {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(
          particles: List.generate(
            40,
            (i) => _ConfettiParticle(
              x: Random().nextDouble(),
              y: Random().nextDouble() * 0.5,
              color: [WC.primary, WC.secondary, WC.accent, WC.success, const Color(0xFFFFB84C)][i % 5],
              size: Random().nextDouble() * 8 + 4,
            ),
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

// ===  HELPER WIDGETS ===

class _KapsulBox extends StatelessWidget {
  final int index;
  static const _colors = [WC.primary, WC.secondary, WC.accent];
  static const _emojis = ['🎲', '🎁', '✨'];

  const _KapsulBox({required this.index});

  @override
  Widget build(BuildContext context) {
    final color = _colors[index];
    return Container(
      width: 90,
      height: 110,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_emojis[index], style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text('Kapsul', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
          Text('${index + 1}', style: GoogleFonts.poppins(fontSize: 10, color: color.withOpacity(0.6))),
        ],
      ),
    );
  }
}

class _StickerResultCard extends StatelessWidget {
  final Map<String, String> sticker;
  const _StickerResultCard({required this.sticker});

  Color _rarityColor() {
    switch (sticker['rarity']) {
      case 'Legendary!': return const Color(0xFFFFB84C);
      case 'Langka': return WC.primary;
      case 'Lumayan': return WC.secondary;
      default: return WC.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _rarityColor();
    return Container(
      padding: const EdgeInsets.all(12),
      width: 88,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Text(sticker['emoji']!, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 6),
          Text(sticker['name']!, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: WC.textDark), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
            child: Text(sticker['rarity']!, style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.w800, color: color)),
          ),
        ],
      ),
    );
  }
}

// Simple confetti data model
class _ConfettiParticle {
  final double x, y, size;
  final Color color;
  _ConfettiParticle({required this.x, required this.y, required this.size, required this.color});
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color.withOpacity(0.8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(p.x * size.width, p.y * size.height, p.size, p.size * 0.5),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
