import 'package:flutter/material.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_icon.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class DapurErniScreen extends StatelessWidget {
  const DapurErniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: 'Dapur Erni',
      currentIndex: 4,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                NeonIcon(label: 'Teh Erni', color: WarungColors.accent),
                SizedBox(width: 16),
                Expanded(
                  child: Text('Profil & Dompet Kopi',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoTile('Saldo Kopi', '50 Kopi'),
            const SizedBox(height: 12),
            _buildInfoTile('Hutang Kasbon', '0 Kopi'),
            const SizedBox(height: 12),
            _buildInfoTile('Badge', 'Anak Baru'),
            const SizedBox(height: 20),
            KopiButton(
              label: 'Chat Teh Erni',
              onPressed: () {
                Navigator.pushNamed(context, Routes.chat);
              },
            ),
            const SizedBox(height: 16),
            KopiButton(
              label: 'Logout',
              onPressed: () => _showLogoutConfirm(context),
            ),
          ],
        ),
      ),
      showFab: false,
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar Warung'),
          content: const Text(
              'Yakin mau keluar bro? Kopi lo masih ada lho. Yakin? ☕'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(Routes.splash));
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WarungColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WarungColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
