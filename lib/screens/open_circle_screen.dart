import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class OpenCircleScreen extends StatefulWidget {
  const OpenCircleScreen({super.key});

  @override
  State<OpenCircleScreen> createState() => _OpenCircleScreenState();
}

class _OpenCircleScreenState extends State<OpenCircleScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  final List<Map<String, dynamic>> _circles = [
    {
      'title': 'Makan Bakso Jam 10',
      'description': 'Butuh 2 orang, ketemu langsung',
      'joined': 12
    },
    {
      'title': 'Nongkrong Kopi',
      'description': 'Cari yang suka curhat ringan',
      'joined': 8
    }
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _openCircle() {
    final t = _titleCtrl.text.trim();
    final d = _descCtrl.text.trim();
    if (t.isEmpty || d.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi judul dan deskripsi dulu.')),
      );
      return;
    }

    setState(() {
      _circles.insert(0, {'title': t, 'description': d, 'joined': 1});
      _titleCtrl.clear();
      _descCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Circle berhasil dibuka.')),
    );
  }

  void _join(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gabung'),
        content: Text('Kamu berhasil gabung ke "$title".'),
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
      title: 'Open Circle',
      currentIndex: 3,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cari Genk', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Buka circle aktivitas dan undang warga lain buat join.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: 'Judul aktivitas',
                filled: true,
                fillColor: WarungColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: WarungColors.primary.withOpacity(0.3), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: WarungColors.primary.withOpacity(0.3), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: WarungColors.primary, width: 2.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Deskripsi singkat',
                filled: true,
                fillColor: WarungColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: WarungColors.primary.withOpacity(0.3), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: WarungColors.primary.withOpacity(0.3), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: WarungColors.primary, width: 2.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 18),
            KopiButton(
              label: 'Buka Circle',
              onPressed: _openCircle,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: _circles
                    .map((c) => _buildCircleCard(
                        context, c['title'], c['description'], c['joined']))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleCard(
      BuildContext context, String title, String description, int joined) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: WarungColors.primary.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0E6D2), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person,
                        color: Color(0xFFFF6B35), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$joined orang sudah gabung',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _join(title),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: WarungColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Gabung',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
