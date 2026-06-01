import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';

// Social Feed Screen — now themed as Posko Archive view
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'George L.',
      'character': 'Kucing',
      'time': '2 jam lalu',
      'text': 'Naik gunung sendirian itu sepi, tapi pemandangannya keren banget! Mana ada yang mau ngajak naik gunung? Gas bareng! 🏔️',
      'reactions': {'😂': 6, '👏': 35, '🥲': 4, '🫣': 2},
      'comments': 15,
    },
    {
      'author': 'Vitaliy B.',
      'character': 'Abang Lapak',
      'time': '3 jam lalu',
      'text': 'Kopi latte kelapa hari ini JUARA banget! Mana ada warung kopi langganan kalian? Rekomen dong, biar makin rame tongkrongan! ☕🥥',
      'reactions': {'😂': 2, '👏': 18, '🥲': 1, '🫣': 0},
      'comments': 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarungColors.background,
      appBar: AppBar(
        title: const Text(
          'Arsip Posko',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800, fontSize: 18, color: WarungColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: WarungColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
              child: const Text('Ke Posko 🏠', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: WarungColors.primary, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final cardColors = [const Color(0xFFFFF9C4), const Color(0xFFC8E6C9)];
          return _buildPost(context, post, cardColors[index % cardColors.length]);
        },
      ),
    );
  }

  Widget _buildPost(BuildContext context, Map<String, dynamic> post, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NeonGlassPortrait(character: post['character'], size: 38, animate: false),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['author'], style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1A1A2E))),
                    Text(post['time'], style: const TextStyle(fontFamily: 'Nunito', fontSize: 10, color: Color(0xFF666680))),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Color(0xFF666680)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post['text'],
            style: const TextStyle(fontFamily: 'Comic Neue', fontSize: 14, fontWeight: FontWeight.w700, height: 1.4, color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.black12, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: ['😂', '👏', '🥲', '🫣'].map((emoji) {
                  final count = (post['reactions'] as Map<String, dynamic>)[emoji] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 2),
                        Text('$count', style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1A1A2E))),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  const Icon(Icons.comment_outlined, size: 14, color: Color(0xFF666680)),
                  const SizedBox(width: 4),
                  Text('${post['comments']} komentar', style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, color: Color(0xFF666680))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
