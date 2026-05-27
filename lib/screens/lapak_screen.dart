import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class LapakScreen extends StatefulWidget {
  const LapakScreen({super.key});

  @override
  State<LapakScreen> createState() => _LapakScreenState();
}

class _LapakScreenState extends State<LapakScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();

  final List<Map<String, dynamic>> _lapaks = [
    {
      'title': 'Jual Gorengan',
      'description': 'Harganya 10 Kopi, siap kirim sehat.',
      'rating': 4.9
    },
    {
      'title': 'Sewa Meja 1 Hari',
      'description': 'Tampil di feed posko selama 1 hari.',
      'rating': 4.7
    }
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _pasangLapak() {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final price = _priceCtrl.text.trim();
    if (name.isEmpty || desc.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi info lapak dulu.')),
      );
      return;
    }

    setState(() {
      _lapaks.insert(0, {'title': name, 'description': desc, 'rating': 5.0});
      _nameCtrl.clear();
      _descCtrl.clear();
      _priceCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lapak berhasil dipasang.')));
  }

  void _lihatLapak(Map<String, dynamic> lapak) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lapak['title']),
        content: Text('${lapak['description']}\n\nRating: ${lapak['rating']}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: 'Abang Lapak',
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Buka Lapak', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 18),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Nama produk/jasa'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Deskripsi singkat'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _priceCtrl,
              decoration: const InputDecoration(hintText: 'Harga dalam Kopi'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            KopiButton(label: 'Pasang Lapak', onPressed: _pasangLapak),
            const SizedBox(height: 24),
            Text('Lapak Aktif', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ..._lapaks.map((l) => _buildLapakCard(
                context, l['title'], l['description'], l['rating'] as double)),
          ],
        ),
      ),
    );
  }

  Widget _buildLapakCard(
      BuildContext context, String title, String description, double rating) {
    final lapak = {
      'title': title,
      'description': description,
      'rating': rating
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WarungColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WarungColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rating $rating ⭐',
                  style: Theme.of(context).textTheme.bodyMedium),
              KopiButton(label: 'Lihat', onPressed: () => _lihatLapak(lapak)),
            ],
          ),
        ],
      ),
    );
  }
}
