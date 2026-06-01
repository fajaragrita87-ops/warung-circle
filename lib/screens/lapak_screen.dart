import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class LapakScreen extends StatefulWidget {
  const LapakScreen({super.key});

  @override
  State<LapakScreen> createState() => _LapakScreenState();
}

class _LapakScreenState extends State<LapakScreen> {
  String _activeCategory = 'Semua';

  final _categories = ['Semua', 'Makanan', 'Jasa', 'Barang', 'Digital'];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Nasi Goreng Spesial',
      'seller': 'Warung Pak Bejo',
      'price': 15000,
      'emoji': '🍳',
      'color': const Color(0xFFFFF3E0),
      'rating': 4.9,
      'sold': 234,
      'category': 'Makanan',
      'kopi': 5,
      'type': 'WTS',
    },
    {
      'name': 'Jasa Edit Video',
      'seller': 'Dika Studio',
      'price': 75000,
      'emoji': '🎬',
      'color': const Color(0xFFE8F1FF),
      'rating': 4.7,
      'sold': 45,
      'category': 'Jasa',
      'kopi': 25,
      'type': 'WTS',
    },
    {
      'name': 'Baju Batik Motif Baru',
      'seller': 'Toko Sari',
      'price': 85000,
      'emoji': '👗',
      'color': const Color(0xFFF3E5F5),
      'rating': 4.8,
      'sold': 67,
      'category': 'Barang',
      'kopi': 30,
      'type': 'WTS',
    },
    {
      'name': 'Template Instagram Pack',
      'seller': 'Dika Design',
      'price': 35000,
      'emoji': '✨',
      'color': const Color(0xFFE8F8EF),
      'rating': 5.0,
      'sold': 123,
      'category': 'Digital',
      'kopi': 12,
      'type': 'WTS',
    },
    {
      'name': 'Es Teh Susu Brown Sugar',
      'seller': 'Teh Erni Drinks',
      'price': 12000,
      'emoji': '🧋',
      'color': const Color(0xFFFFF9C4),
      'rating': 4.9,
      'sold': 456,
      'category': 'Makanan',
      'kopi': 4,
      'type': 'WTS',
    },
    {
      'name': 'Jasa Titip Belanja',
      'seller': 'Abang Lapak',
      'price': 10000,
      'emoji': '🛍️',
      'color': const Color(0xFFFFEDE8),
      'rating': 4.6,
      'sold': 89,
      'category': 'Jasa',
      'kopi': 3,
      'type': 'WTB',
    },
  ];

  List<Map<String, dynamic>> get _filtered => _activeCategory == 'Semua'
      ? _products
      : _products.where((p) => p['category'] == _activeCategory).toList();

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '🏪 Lapak Warung',
      currentIndex: 0,
      showAppBar: true,
      body: Column(
        children: [
          // Search bar
          FadeScaleIn(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari produk di lapak...',
                  prefixIcon: Icon(Icons.search_rounded, color: WC.textLight),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Category filter
          FadeScaleIn(
            delay: const Duration(milliseconds: 100),
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (ctx, i) {
                  final active = _categories[i] == _activeCategory;
                  return Padding(
                    padding: EdgeInsets.only(right: i < _categories.length - 1 ? 8 : 0),
                    child: ScaleButton(
                      onTap: () => setState(() => _activeCategory = _categories[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? WC.primary : WC.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: active ? Colors.transparent : WC.border),
                        ),
                        child: Text(
                          _categories[i],
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: active ? Colors.white : WC.textMid),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Product grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => FadeScaleIn(
                delay: Duration(milliseconds: 50 * i),
                child: _ProductCard(product: _filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _wishlist = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final Color bg = p['color'] as Color;

    return ScaleButton(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: WC.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WC.border),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image area
            Stack(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(p['emoji'] as String, style: const TextStyle(fontSize: 52)),
                  ),
                ),
                // WTS / WTB Badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: p['type'] == 'WTS' ? WC.primary : WC.secondary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: (p['type'] == 'WTS' ? WC.primary : WC.secondary).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      p['type'] == 'WTS' ? '🏷️ JUAL (WTS)' : '🔍 CARI (WTB)',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _wishlist = !_wishlist),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(_wishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16, color: _wishlist ? WC.primary : WC.textLight),
                    ),
                  ),
                ),
              ],
            ),

            // Product info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['name'] as String,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: WC.textDark),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(p['seller'] as String, style: GoogleFonts.nunito(fontSize: 10, color: WC.textLight)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: WC.warning),
                      Text(' ${p['rating']} • ${p['sold']} terjual',
                          style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w600, color: WC.textMid)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rp ${_formatPrice(p['price'] as int)}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 12, color: WC.primary),
                          ),
                          Text('atau ${p['kopi']} ☕', style: GoogleFonts.nunito(fontSize: 9, color: WC.textLight)),
                        ],
                      ),
                      ScaleButton(
                        onTap: () {},
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(color: WC.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000) return '${price ~/ 1000}k';
    return price.toString();
  }
}
