import 'package:flutter/material.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class RuangTengahScreen extends StatefulWidget {
  const RuangTengahScreen({super.key});

  @override
  State<RuangTengahScreen> createState() => _RuangTengahScreenState();
}

class _RuangTengahScreenState extends State<RuangTengahScreen> {
  final TextEditingController _mySkillCtrl = TextEditingController();
  final TextEditingController _wantSkillCtrl = TextEditingController();

  final List<Map<String, dynamic>> _matches = [
    {
      'title': 'Ngajar Figma',
      'subtitle': 'Butuh belajar desain UI',
      'rating': 4.8
    },
    {
      'title': 'Belajar JavaScript',
      'subtitle': 'Saling bantu project app',
      'rating': 4.6
    }
  ];

  @override
  void dispose() {
    _mySkillCtrl.dispose();
    _wantSkillCtrl.dispose();
    super.dispose();
  }

  void _searchPartner() {
    final my = _mySkillCtrl.text.trim();
    final want = _wantSkillCtrl.text.trim();
    if (my.isEmpty || want.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi kedua field dulu ya bro.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        final results = _matches
            .where((m) =>
                m['title'].toLowerCase().contains(want.toLowerCase()) ||
                m['subtitle'].toLowerCase().contains(want.toLowerCase()))
            .toList();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: results.isEmpty
              ? const Text('Gak ketemu partner, coba ubah kata kunci.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: results
                      .map((r) => ListTile(
                            title: Text(r['title']),
                            subtitle: Text(r['subtitle']),
                            trailing: KopiButton(
                              label: 'Gabung',
                              onPressed: () {
                                Navigator.pop(context);
                                _joinCircle(r['title']);
                              },
                            ),
                          ))
                      .toList(),
                ),
        );
      },
    );
  }

  void _joinCircle(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gabung'),
        content: Text('Berhasil gabung ke "$title". Selamat!'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: 'Ruang Tengah',
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skill Swap', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            Text('Cari partner belajar dan barter skill di sini.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _mySkillCtrl,
              decoration: const InputDecoration(
                hintText: 'Skill kamu',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _wantSkillCtrl,
              decoration: const InputDecoration(
                hintText: 'Skill yang kamu mau belajar',
              ),
            ),
            const SizedBox(height: 28),
            KopiButton(
              label: 'Cari Partner',
              onPressed: _searchPartner,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: _matches
                    .map((m) => _buildCard(
                        context, m['title'], m['subtitle'], m['rating']))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, String subtitle, double rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rating $rating ⭐',
                    style: Theme.of(context).textTheme.bodyMedium),
                KopiButton(
                  label: 'Gabung',
                  onPressed: () => _joinCircle(title),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
