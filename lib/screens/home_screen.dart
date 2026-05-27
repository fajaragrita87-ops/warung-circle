import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/bon_warung_card.dart';
import 'package:warung_circle/widgets/post_card.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedFilterIndex = 0;

  final filters = [
    FeedCategory.semua,
    FeedCategory.ruangTengah,
    FeedCategory.titipCerita,
    FeedCategory.openCircle,
    FeedCategory.curhat,
  ];

  final posts = [
    {
      'title': 'Open Circle Makan Bakso',
      'subtitle': 'Butuh 2 orang nongkrong jam 10.',
      'tag': 'Open Circle',
      'reactionCount': 24,
      'category': FeedCategory.openCircle,
    },
    {
      'title': 'Titip Cerita Lebay',
      'subtitle': 'Ditinggalin pas ultah? AI bakal bikin teks gila.',
      'tag': 'Titip Cerita',
      'reactionCount': 18,
      'category': FeedCategory.titipCerita,
    },
    {
      'title': 'Skill Swap Design',
      'subtitle': 'Cari partner ngoding UI/UX.',
      'tag': 'Ruang Tengah',
      'reactionCount': 32,
      'category': FeedCategory.ruangTengah,
    },
  ];

  List<Map<String, Object>> get filteredPosts {
    final filter = filters[selectedFilterIndex];
    if (filter == FeedCategory.semua) return posts;
    return posts.where((post) => post['category'] == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: 'Posko',
      currentIndex: 0,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, Routes.chat),
          icon: const Icon(Icons.chat_bubble_outline,
              color: WarungColors.primary),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final label = filters[index];
                  final selected = index == selectedFilterIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilterIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            selected ? WarungColors.primary : WarungColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? WarungColors.primary
                              : WarungColors.border,
                        ),
                      ),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: selected
                                  ? Colors.white
                                  : WarungColors.textPrimary,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: filteredPosts.length + 1,
                itemBuilder: (context, index) {
                  if (index == filteredPosts.length) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bon Warung',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        BonWarungCard(title: 'Gorengan (Boost Post)', price: 2),
                        BonWarungCard(title: 'Buka Chat', price: 5),
                        BonWarungCard(title: 'Sewa Meja 1 Hari', price: 20),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                  final post = filteredPosts[index];
                  return PostCard(
                    title: post['title'] as String,
                    subtitle: post['subtitle'] as String,
                    tag: post['tag'] as String,
                    reactionCount: post['reactionCount'] as int,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
