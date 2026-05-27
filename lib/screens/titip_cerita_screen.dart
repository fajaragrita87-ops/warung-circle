import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warung_circle/services/gemini_service.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';

class TitipCeritaScreen extends StatefulWidget {
  const TitipCeritaScreen({super.key});

  @override
  State<TitipCeritaScreen> createState() => _TitipCeritaScreenState();
}

class _TitipCeritaScreenState extends State<TitipCeritaScreen> {
  final TextEditingController storyController = TextEditingController();
  final GeminiService geminiService = GeminiService();
  String output = '';
  bool isLoading = false;

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  Future<void> _generateCerita() async {
    if (storyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi masalah dulu ya, bro.')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final ok = await geminiService.checkContent(storyController.text);
      if (!mounted) return;
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konten tidak diperbolehkan.')),
        );
        return;
      }

      final result =
          await geminiService.generateTitipCerita(storyController.text);
      if (!mounted) return;
      setState(() {
        output = result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat cerita: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _copyOutput() async {
    if (output.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: output));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teks disalin ke clipboard')));
  }

  void _clearOutput() {
    setState(() {
      output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: 'Titip Cerita',
      currentIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: WarungColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: WarungColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WarungColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.auto_stories, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Titip Cerita',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          'Tekan tombol dan biarkan Teh Erni bikin cerita lebaymu siap dishare.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: storyController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Contoh: Ditinggalin pas ultah...',
              ),
            ),
            const SizedBox(height: 18),
            KopiButton(
              label: isLoading ? 'Membuat...' : 'Buat Cerita Lebay',
              onPressed: isLoading ? () {} : _generateCerita,
            ),
            const SizedBox(height: 20),
            if (output.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: WarungColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: WarungColors.border),
                ),
                padding: const EdgeInsets.all(18),
                child:
                    Text(output, style: Theme.of(context).textTheme.bodyMedium),
              ),
            if (output.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: KopiButton(label: 'Salin', onPressed: _copyOutput),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WarungColors.border,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: _clearOutput,
                      child: const Text('Bersihkan'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
