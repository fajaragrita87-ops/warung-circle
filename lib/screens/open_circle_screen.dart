import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/pojok_suara_widget.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class OpenCircleScreen extends StatefulWidget {
  const OpenCircleScreen({super.key});

  @override
  State<OpenCircleScreen> createState() => _OpenCircleScreenState();
}

class _OpenCircleScreenState extends State<OpenCircleScreen> {
  final List<Map<String, dynamic>> _circles = [
    {
      'name': 'Ngopi Bareng Sabtu Sore',
      'host': 'Kak Budi',
      'character': 'Pak RT',
      'time': 'Sabtu, 16:00',
      'place': 'Warkop Pak Bejo, Blok B',
      'members': ['😊', '😎', '🤓', '😄'],
      'maxMembers': 10,
      'currentMembers': 7,
      'category': 'Nongkrong',
      'color': WC.primary,
      'distance': 1.2,
    },
    {
      'name': 'Bakso Bareng + Gossip',
      'host': 'Mba Sari',
      'character': 'Teh Erni',
      'time': 'Minggu, 12:00',
      'place': 'Bakso Cak Min, RT 03',
      'members': ['🍜', '😋', '😊'],
      'maxMembers': 8,
      'currentMembers': 3,
      'category': 'Makan',
      'color': WC.accent,
      'distance': 3.5,
    },
    {
      'name': 'Mabar Mobile Legends',
      'host': 'Bang Dika',
      'character': 'Kucing',
      'time': 'Setiap Malam, 20:00',
      'place': 'Online — Link dikirimi',
      'members': ['🎮', '😤', '💪', '🔥', '😈'],
      'maxMembers': 5,
      'currentMembers': 5,
      'category': 'Gaming',
      'color': WC.kucing,
      'distance': 0.8,
    },
    {
      'name': 'Kajian Rutin Malam Jumat',
      'host': 'Ustad Fahmi',
      'character': 'Ustad',
      'time': 'Kamis Malam, 19:30',
      'place': 'Mushola Al-Amin RT 05',
      'members': ['🕌', '😊', '🤲'],
      'maxMembers': 20,
      'currentMembers': 12,
      'category': 'Religi',
      'color': WC.ustad,
      'distance': 4.9,
    },
  ];

  String _activeFilter = 'Semua';
  final _filters = ['Semua', 'Nongkrong', 'Makan', 'Gaming', 'Religi'];
  double _maxDistance = 5.0;

  List<Map<String, dynamic>> get _filtered {
    final catFiltered = _activeFilter == 'Semua'
        ? _circles
        : _circles.where((c) => c['category'] == _activeFilter).toList();
    return catFiltered.where((c) => (c['distance'] as double) <= _maxDistance).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '👥 Open Circle',
      currentIndex: 3,
      showFab: false,
      // === POJOKAN SUARA: Mic button injected to AppBar actions ===
      actions: [
        const PojokSuaraButton(),
        const SizedBox(width: 16),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // Header
          FadeScaleIn(
            child: _buildHeader(),
          ),

          const SizedBox(height: 16),

          // Filter chips
          FadeScaleIn(
            delay: const Duration(milliseconds: 100),
            child: _buildFilters(),
          ),

          const SizedBox(height: 12),

          // Distance filter slider
          FadeScaleIn(
            delay: const Duration(milliseconds: 120),
            child: _buildDistanceFilter(),
          ),

          const SizedBox(height: 16),

          // Circles list
          if (_filtered.isEmpty)
            FadeScaleIn(
              delay: const Duration(milliseconds: 150),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    const Text('📍', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'Gak ada Circle di radius segitu, Bestie! 🥺',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: WC.textDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Coba geser slidenya atau ganti filter biar makin rame!',
                      style: GoogleFonts.nunito(fontSize: 12, color: WC.textLight),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(
              _filtered.length,
              (i) => FadeScaleIn(
                delay: Duration(milliseconds: 150 + i * 70),
                child: _CircleCard(circle: _filtered[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [WC.secondary.withOpacity(0.12), WC.secondary.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.secondary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Open Circle 👥', style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 20, color: WC.textDark)),
                const SizedBox(height: 4),
                Text('Ikut aktivitas seru bareng warga warung!', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: WC.textMid)),
                const SizedBox(height: 12),
                KopiButton(
                  label: '+ Buka Circle Baru',
                  onPressed: () {},
                  color: WC.secondary,
                  fullWidth: false,
                  height: 40,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🎉', style: TextStyle(fontSize: 56)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (ctx, i) {
          final active = _filters[i] == _activeFilter;
          return Padding(
            padding: EdgeInsets.only(right: i < _filters.length - 1 ? 8 : 0),
            child: ScaleButton(
              onTap: () => setState(() => _activeFilter = _filters[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? WC.primary : WC.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: active ? Colors.transparent : WC.border),
                ),
                child: Text(
                  _filters[i],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : WC.textMid,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('📍', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'Filter Jarak Maksimal',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: WC.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: WC.secondaryLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${_maxDistance.toStringAsFixed(1)} km',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: WC.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: WC.secondary,
              inactiveTrackColor: WC.border,
              thumbColor: WC.secondary,
              overlayColor: WC.secondary.withOpacity(0.12),
              valueIndicatorColor: WC.secondary,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _maxDistance,
              min: 0.5,
              max: 5.0,
              divisions: 9,
              onChanged: (val) {
                setState(() {
                  _maxDistance = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleCard extends StatefulWidget {
  final Map<String, dynamic> circle;
  const _CircleCard({required this.circle});

  @override
  State<_CircleCard> createState() => _CircleCardState();
}

class _CircleCardState extends State<_CircleCard> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.circle;
    final Color color = c['color'] as Color;
    final int current = _joined ? (c['currentMembers'] as int) + 1 : c['currentMembers'] as int;
    final int max = c['maxMembers'] as int;
    final bool isFull = current >= max;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NeonGlassPortrait(character: c['character'] as String, size: 44, animate: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: WC.textDark)),
                      Text('Dibikin ${c['host']}', style: GoogleFonts.nunito(fontSize: 11, color: WC.textLight)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(100)),
                  child: Text(c['category'] as String, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _InfoChip(icon: Icons.schedule_rounded, text: c['time'] as String),
                const SizedBox(width: 8),
                _InfoChip(icon: Icons.location_on_rounded, text: c['place'] as String),
                const SizedBox(width: 8),
                _InfoChip(icon: Icons.near_me_rounded, text: '${(c['distance'] as double).toStringAsFixed(1)} km'),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                // Member avatars
                if ((c['members'] as List<String>).isNotEmpty) ...[
                  SizedBox(
                    width: 28.0 + ((c['members'] as List<String>).take(4).length - 1) * 20.0,
                    height: 28,
                    child: Stack(
                      children: List.generate((c['members'] as List<String>).take(4).length, (index) {
                        final m = (c['members'] as List<String>)[index];
                        return Positioned(
                          left: index * 20.0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(color: WC.surface, width: 2),
                            ),
                            child: Center(child: Text(m, style: const TextStyle(fontSize: 12))),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                // Visual Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: WC.bg,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: WC.border, width: 0.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: current / max,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(isFull ? WC.accent : WC.success),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFull ? '🔴 Penuh ($current/$max)' : '🟢 Terbuka ($current/$max)',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isFull ? WC.accent : WC.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ScaleButton(
                  onTap: isFull && !_joined ? () {} : () => setState(() => _joined = !_joined),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: _joined ? WC.success : isFull ? WC.border : color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      _joined ? 'Ikut ✓' : isFull ? 'Penuh' : 'Gabung',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isFull && !_joined ? WC.textLight : Colors.white,
                      ),
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: WC.bg, borderRadius: BorderRadius.circular(100), border: Border.all(color: WC.border)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: WC.textLight),
            const SizedBox(width: 4),
            Flexible(child: Text(text, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: WC.textMid), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
