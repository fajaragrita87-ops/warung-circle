import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/utils/file_picker_helper.dart';
import 'package:warung_circle/widgets/bounce_mascot.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';
import 'package:warung_circle/services/firebase_service.dart';

class DapurErniScreen extends StatefulWidget {
  const DapurErniScreen({super.key});

  @override
  State<DapurErniScreen> createState() => _DapurErniScreenState();
}

class _DapurErniScreenState extends State<DapurErniScreen> {
  double get _kopiBalance => WS.kopiBalance;
  set _kopiBalance(double val) => WS.kopiBalance = val;

  double get _kopiDebt => WS.kopiDebt;
  set _kopiDebt(double val) => WS.kopiDebt = val;

  double get _respectPoints => WS.respectPoints;
  set _respectPoints(double val) => WS.respectPoints = val;

  double get _redFlags => WS.redFlags;
  set _redFlags(double val) => WS.redFlags = val;

  bool _showTopup = false;

  final List<Map<String, dynamic>> _badges = [
    {'emoji': '🔥', 'label': 'Aktif 7 Hari', 'color': WC.primary},
    {'emoji': '💬', 'label': 'Curhat Pro', 'color': WC.secondary},
    {'emoji': '🛍️', 'label': 'Pedagang', 'color': WC.accent},
    {'emoji': '🤝', 'label': 'Skill Swap', 'color': WC.success},
  ];

  final List<Map<String, dynamic>> _transactions = [
    {'type': 'in', 'label': 'Top Up Kopi', 'amount': 50.0, 'time': '2 jam lalu'},
    {'type': 'out', 'label': 'Beli di Lapak', 'amount': -20.0, 'time': '5 jam lalu'},
    {'type': 'in', 'label': 'Bonus Login', 'amount': 10.0, 'time': '1 hari lalu'},
    {'type': 'out', 'label': 'Traktir Teman', 'amount': -15.0, 'time': '2 hari lalu'},
  ];

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: WS.isLoggedIn ? '☕ Dapur ${WS.userName}' : '☕ Dapur Teh Erni',
      currentIndex: 4,
      showFab: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        children: [
          // Pink header with mascot
          _buildProfileHeader(),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildStatsRow(),
          ),

          const SizedBox(height: 20),

          // Kopi wallet card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FadeScaleIn(
              delay: const Duration(milliseconds: 200),
              child: _buildWalletCard(),
            ),
          ),

          const SizedBox(height: 20),

          // Vibe Check Reputation (Green/Red Flags)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildReputationSection(),
          ),

          const SizedBox(height: 20),

          // Skill Swap card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FadeScaleIn(
              delay: const Duration(milliseconds: 250),
              child: _buildSkillSwapSection(),
            ),
          ),

          const SizedBox(height: 20),

          // Badges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildBadgesSection(),
          ),

          const SizedBox(height: 20),

          // Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTransactionsSection(),
          ),

          const SizedBox(height: 20),

          // Settings & Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSettingsSection(),
          ),

          // Superadmin Panel (only visible to superadmin)
          if (WS.userRole == 'superadmin') ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSuperadminPanel(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WC.primary, Color(0xFFFF8C69)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: WC.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Interactive Avatar with Pick Photo functionality
          GestureDetector(
            onTap: () async {
              try {
                final bytes = await FilePickerHelper.pickImage();
                if (bytes != null) {
                  final base64Image = base64Encode(bytes);
                  setState(() {
                    WS.userAvatar = base64Image;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Foto profil berhasil diperbarui! 📸✨',
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: WC.success,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gagal mengambil foto: $e',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      backgroundColor: WC.primary,
                    ),
                  );
                }
              }
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                image: WS.userAvatar.isNotEmpty
                    ? DecorationImage(
                        image: MemoryImage(base64Decode(WS.userAvatar)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: WS.userAvatar.isEmpty
                  ? const Center(
                      child: Tooltip(
                        message: 'Ketuk untuk ganti foto',
                        child: Text('😊', style: TextStyle(fontSize: 36)),
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WS.isLoggedIn ? WS.userName : 'Sobat Warung',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  WS.isLoggedIn ? '@${WS.userName.toLowerCase().replaceAll(' ', '')} • Anak Nongkrong 🔥' : '@sobatwarung • Anak Nongkrong 🔥',
                  style: GoogleFonts.nunito(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Pangkat: Anak Nongkrong ☕',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '75 cerita lagi menuju Suhu Warung 👑',
                  style: GoogleFonts.nunito(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Cerita', 'value': '24', 'emoji': '📝'},
      {'label': 'Warga Follow', 'value': '183', 'emoji': '👥'},
      {'label': 'Warga Diikuti', 'value': '97', 'emoji': '🤝'},
      {'label': 'Tukar Skill', 'value': '12', 'emoji': '🔄'},
    ];

    return FadeScaleIn(
      delay: const Duration(milliseconds: 100),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: WC.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: WC.border),
              ),
              child: Column(
                children: [
                  Text(s['emoji']!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    s['value']!,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: WC.textDark,
                    ),
                  ),
                  Text(
                    s['label']!,
                    style: GoogleFonts.nunito(
                      fontSize: 9,
                      color: WC.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.border),
        boxShadow: [
          BoxShadow(
            color: WC.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('☕', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Dompet Kopi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: WC.textDark,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kopiDebt > 0 ? WC.warningLight : WC.successLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  _kopiDebt > 0 ? 'Ada Kasbon 💸' : 'Bebas Kasbon ✅',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _kopiDebt > 0 ? WC.warning : WC.success,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_kopiBalance.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: WC.textDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 6),
                    child: Text(
                      'Kopi',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: WC.textMid,
                      ),
                    ),
                  ),
                ],
              ),
              if (_kopiDebt > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '-${_kopiDebt.toStringAsFixed(0)} Kopi',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WC.danger,
                      ),
                    ),
                    Text(
                      'Hutang Kasbon 🚩',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: WC.textLight,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: KopiButton(
                  label: '+ Top Up',
                  onPressed: _showTopUpSheet,
                  height: 44,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KopiOutlineButton(
                  label: '🎁 Traktir Bestie',
                  onPressed: _showTraktirSheet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_kopiDebt == 0)
                Expanded(
                  child: KopiOutlineButton(
                    label: '💸 Ajukan Kasbon (+15 Kopi)',
                    onPressed: _takeKasbon,
                  ),
                )
              else
                Expanded(
                  child: KopiButton(
                    label: '🪙 Bayar Kasbon',
                    onPressed: _payKasbon,
                    color: WC.secondary,
                    height: 44,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _takeKasbon() {
    setState(() {
      _kopiBalance += 15;
      _kopiDebt = 15;
      _transactions.insert(0, {
        'type': 'in',
        'label': 'Pinjam Kasbon 1x',
        'amount': 15.0,
        'time': 'Baru saja'
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: WC.warning,
        content: Text('Kasbon 15 Kopi aktif Ngab! Pak RT udah nyatet di buku kasbon 📝'),
      ),
    );
  }

  void _payKasbon() {
    if (_kopiBalance < _kopiDebt) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: WC.danger,
          content: Text('Kopi lo ga cukup buat bayar kasbon, Bestie! Top Up dulu lah ☕'),
        ),
      );
      return;
    }
    setState(() {
      _kopiBalance -= _kopiDebt;
      _kopiDebt = 0;
      _transactions.insert(0, {
        'type': 'out',
        'label': 'Bayar Kasbon',
        'amount': -15.0,
        'time': 'Baru saja'
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: WC.success,
        content: Text('Hutang lunas, jiwa tenang! Pak RT senyum lebar 😊'),
      ),
    );
  }

  void _showTopUpSheet() {
    final List<Map<String, dynamic>> packages = [
      {'name': 'Ngopi Hemat', 'price': 'Rp 10.000', 'kopi': 15, 'respect': 0},
      {'name': 'Ngopi Vibe', 'price': 'Rp 25.000', 'kopi': 40, 'respect': 5},
      {'name': 'Suhu Santai', 'price': 'Rp 50.000', 'kopi': 90, 'respect': 15},
      {'name': 'Sultan Nongkrong', 'price': 'Rp 100.000', 'kopi': 200, 'respect': 50},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: WC.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: WC.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Top Up Kopi Posko ☕',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: WC.textDark,
              ),
            ),
            Text(
              'Isi amunisi Kopi lo biar bisa nongkrong sepuasnya!',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: WC.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WC.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: WC.border),
                    ),
                    child: Row(
                      children: [
                        const Text('☕', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pkg['name'] as String,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: WC.textDark,
                                ),
                              ),
                              Text(
                                '${pkg['kopi']} Kopi ${pkg['respect'] > 0 ? '+ bonus ${pkg['respect']} Respect 🫡' : ''}',
                                style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  color: WC.textMid,
                                ),
                              ),
                            ],
                          ),
                        ),
                        KopiButton(
                          label: pkg['price'] as String,
                          onPressed: () {
                            Navigator.pop(ctx);
                            double addedKopi = (pkg['kopi'] as int).toDouble();
                            double addedRespect = (pkg['respect'] as int).toDouble();
                            setState(() {
                              if (_kopiDebt > 0) {
                                double repayment = _kopiDebt;
                                _kopiDebt = 0;
                                _kopiBalance += (addedKopi - repayment);
                                _transactions.insert(0, {
                                  'type': 'in',
                                  'label': 'Top Up ${pkg['name']} (Potong Kasbon)',
                                  'amount': addedKopi - repayment,
                                  'time': 'Baru saja'
                                });
                              } else {
                                _kopiBalance += addedKopi;
                                _transactions.insert(0, {
                                  'type': 'in',
                                  'label': 'Top Up ${pkg['name']}',
                                  'amount': addedKopi,
                                  'time': 'Baru saja'
                                });
                              }
                              _respectPoints += addedRespect;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: WC.success,
                                content: Text('Top Up sukses! +$addedKopi Kopi masuk kantong ☕✨'),
                              ),
                            );
                          },
                          fullWidth: false,
                          height: 32,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTraktirSheet() {
    final List<Map<String, String>> friends = [
      {'name': 'Teh Erni AI 🍵', 'character': 'Teh Erni'},
      {'name': 'Pak RT 👮', 'character': 'Pak RT'},
      {'name': 'Ustad 🕌', 'character': 'Ustad'},
      {'name': 'Hansip Cyber 🚨', 'character': 'Hansip'},
      {'name': 'Kucing Warung 🐱', 'character': 'Kucing'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: WC.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: WC.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Traktir Bestie Posko 🎁',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: WC.textDark,
              ),
            ),
            Text(
              'Traktir 10 Kopi ke warga buat naikin Respect 🫡 lo!',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: WC.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final f = friends[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: WC.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: WC.border),
                    ),
                    child: Row(
                      children: [
                        NeonGlassPortrait(character: f['character']!, size: 38, animate: false),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            f['name']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: WC.textDark,
                            ),
                          ),
                        ),
                        KopiButton(
                          label: 'Traktir (10 ☕)',
                          onPressed: () {
                            if (_kopiBalance < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: WC.danger,
                                  content: Text('Kopi lo kurang, Bestie! Top Up dulu lah ☕🥺'),
                                ),
                              );
                              return;
                            }
                            Navigator.pop(ctx);
                            setState(() {
                              _kopiBalance -= 10;
                              _respectPoints += 8; // Gain respect!
                              _transactions.insert(0, {
                                'type': 'out',
                                'label': 'Traktir ${f['name']}',
                                'amount': -10.0,
                                'time': 'Baru saja'
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: WC.success,
                                content: Text('Traktiran terkirim! Poin Respect lo nambah +8 🫡💚'),
                              ),
                            );
                          },
                          fullWidth: false,
                          height: 32,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    return FadeScaleIn(
      delay: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badge Koleksi 🏅',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: WC.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: _badges
                .map((b) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: (b['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (b['color'] as Color).withOpacity(0.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(b['emoji'] as String,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(
                              b['label'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: b['color'] as Color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return FadeScaleIn(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Transaksi 📋',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: WC.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: WC.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WC.border),
            ),
            child: Column(
              children: _transactions.asMap().entries.map((entry) {
                final i = entry.key;
                final t = entry.value;
                final isIn = t['type'] == 'in';
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isIn ? WC.successLight : WC.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: isIn ? WC.success : WC.primary,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['label'] as String,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: WC.textDark,
                                  ),
                                ),
                                Text(
                                  t['time'] as String,
                                  style: GoogleFonts.nunito(
                                    fontSize: 10,
                                    color: WC.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${isIn ? '+' : ''}${t['amount']?.toStringAsFixed(0)} ☕',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isIn ? WC.success : WC.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < _transactions.length - 1)
                      Divider(height: 1, color: WC.border),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSwapSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WC.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WC.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔄', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Skill Swap Saya',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: WC.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkillItem('🎓 Skill Ditawarkan', 'Design Figma, Flutter Basics'),
          const SizedBox(height: 12),
          _buildSkillItem('🎯 Skill Dibutuhkan', 'Gitar Dasar, Public Speaking'),
          const SizedBox(height: 20),
          KopiButton(
            label: 'Tukar Skill 🔄',
            onPressed: _showSkillMatcherSheet,
            color: WC.secondary,
            height: 44,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(String title, String skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: WC.textLight,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: WC.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: WC.border),
          ),
          child: Text(
            skills,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: WC.textDark,
            ),
          ),
        ),
      ],
    );
  }

  void _showSkillMatcherSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: WC.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: WC.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Skill Swap Matcher ⚡',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: WC.textDark,
              ),
            ),
            Text(
              'Kecocokan berdasarkan skill lo & warga lain!',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: WC.textLight,
              ),
            ),
            const SizedBox(height: 20),

            // Matched partner card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WC.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WC.border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const NeonGlassPortrait(character: 'Abang Lapak', size: 48, animate: false),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dika Pratama',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: WC.textDark,
                              ),
                            ),
                            Text(
                              'Abang Lapak • Tangerang',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                color: WC.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: WC.primaryLight,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '98% Match ⚡',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: WC.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: WC.border),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BISA NGAJAR:', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: WC.textLight)),
                          const SizedBox(height: 2),
                          Text('Gitar Dasar 🎸', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: WC.textDark)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('MAU BELAJAR:', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: WC.textLight)),
                          const SizedBox(height: 2),
                          Text('Design Figma 🎨', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: WC.textDark)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: KopiOutlineButton(
                    label: 'Cari Lain',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KopiButton(
                    label: 'Kirim Request 🤝',
                    onPressed: () {
                      Navigator.pop(ctx);
                      showDialog(
                        context: context,
                        builder: (dCtx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          backgroundColor: WC.bg,
                          title: Row(
                            children: const [
                              Text('🤝', style: TextStyle(fontSize: 22)),
                              SizedBox(width: 8),
                              Text('Request Terkirim!'),
                            ],
                          ),
                          content: Text(
                            'Request barter skill lo udah dikirim ke Dika Pratama. Teh Erni bakal kabarin lo lewat chat kalau dia setuju! 😉',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: WC.textMid,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx),
                              child: Text(
                                'Mantap! 🔥',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: WC.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    color: WC.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSuperadminPanel() {
    final TextEditingController _kopiTargetCtrl = TextEditingController();
    final TextEditingController _kopiAmountCtrl = TextEditingController();
    final TextEditingController _banTargetCtrl = TextEditingController();

    return FadeScaleIn(
      delay: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A0030), Color(0xFF3D0060)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD500F9).withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD500F9).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD500F9).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('👑', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panel Superadmin',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Kontrol penuh Meja Warung 🏰',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD500F9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD500F9).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFD500F9)),
                  ),
                  child: Text(
                    'SUPERADMIN',
                    style: GoogleFonts.poppins(
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFD500F9),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),

            // Navigation to Full Admin Panel Screen
            ScaleButton(
              onTap: () => Navigator.pushNamed(context, Routes.adminPanel),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD500F9), Color(0xFF8E24AA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD500F9).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.dashboard_customize_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'BUKA ADMIN PANEL UTAMA 🚀',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Divider(color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),

            // === ADD KOPI SECTION ===
            Text(
              '☕ Tambah Kopi Warga',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildAdminTextField(
                    controller: _kopiTargetCtrl,
                    hint: 'Email / Kontak warga',
                    icon: Icons.person_search_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildAdminTextField(
                    controller: _kopiAmountCtrl,
                    hint: 'Jumlah Kopi',
                    icon: Icons.coffee_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ScaleButton(
              onTap: () async {
                final target = _kopiTargetCtrl.text.trim();
                final amount = double.tryParse(_kopiAmountCtrl.text.trim()) ?? 0;
                if (target.isEmpty || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Isi email/kontak dan jumlah kopi, Ndan! ☕')),
                  );
                  return;
                }
                try {
                  await FirebaseService().addKopi(target, amount);
                  _kopiTargetCtrl.clear();
                  _kopiAmountCtrl.clear();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: WC.success,
                        content: Text('✅ Berhasil tambah ${amount.toInt()} Kopi ke $target!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: WC.danger,
                        content: Text('❌ Gagal: $e'),
                      ),
                    );
                  }
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: WC.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: WC.success.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    '+ Tambahkan Kopi ☕',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: WC.success,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),

            // === BAN USER SECTION ===
            Text(
              '🚫 Ban Warga Toxic',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            _buildAdminTextField(
              controller: _banTargetCtrl,
              hint: 'Email / Kontak warga yang akan di-ban',
              icon: Icons.person_off_rounded,
            ),
            const SizedBox(height: 10),
            ScaleButton(
              onTap: () async {
                final target = _banTargetCtrl.text.trim();
                if (target.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Isi email/kontak warga yang mau di-ban dulu, Ndan! 🚫')),
                  );
                  return;
                }
                // Show confirmation before banning
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: WC.bg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Row(children: const [
                      Text('🚫', style: TextStyle(fontSize: 22)),
                      SizedBox(width: 8),
                      Text('Konfirmasi Ban'),
                    ]),
                    content: Text(
                      'Yakin mau ban "$target"? Warga ini tidak bisa posting atau komentar lagi.',
                      style: GoogleFonts.nunito(fontSize: 13, color: WC.textDark, fontWeight: FontWeight.w700),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Batalkan', style: GoogleFonts.poppins(color: WC.textMid)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Ban! 🚫', style: GoogleFonts.poppins(color: WC.danger, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                );
                if (confirm != true) return;
                try {
                  await FirebaseService().banUser(target);
                  _banTargetCtrl.clear();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: WC.danger,
                        content: Text('🚫 "$target" berhasil di-ban dari Meja Warung!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: WC.warning,
                        content: Text('❌ Gagal ban: $e'),
                      ),
                    );
                  }
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: WC.danger.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: WC.danger.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    '🚫 Eksekusi Ban',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: WC.danger,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.nunito(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(fontSize: 11, color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD500F9), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildReputationSection() {
    return FadeScaleIn(
      delay: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WC.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: WC.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vibe Check Reputasi 🎭',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: WC.textDark,
              ),
            ),
            const SizedBox(height: 16),
            
            // Respect / Green Flag Bar
            Row(
              children: [
                const Text('🫡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Respect / Green Flag 🟢',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: WC.success,
                            ),
                          ),
                          Text(
                            '${_respectPoints.toStringAsFixed(0)} Pts',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: WC.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_respectPoints / 100).clamp(0.0, 1.0),
                          backgroundColor: WC.successLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(WC.success),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Red Flag Bar
            Row(
              children: [
                const Text('🚩', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Toxic / Red Flag 🔴',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: WC.danger,
                            ),
                          ),
                          Text(
                            '${_redFlags.toStringAsFixed(0)} Pts',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: WC.danger,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_redFlags / 100).clamp(0.0, 1.0),
                          backgroundColor: WC.primaryLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(WC.danger),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return FadeScaleIn(
      delay: const Duration(milliseconds: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan Posko ⚙️',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: WC.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: WC.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WC.border),
            ),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Ganti Nama & Profil',
                  onTap: () {},
                ),
                Divider(height: 1, color: WC.border),
                _buildSettingsTile(
                  icon: Icons.mood_rounded,
                  title: 'Ganti Mood Utama',
                  onTap: () {},
                ),
                Divider(height: 1, color: WC.border),
                _buildSettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifikasi Warung',
                  onTap: () {},
                ),
                // Admin Panel shortcut — only visible to superadmin
                if (WS.userRole == 'superadmin') ...[
                  Divider(height: 1, color: WC.border),
                  ScaleButton(
                    onTap: () => Navigator.pushNamed(context, Routes.adminPanel),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF1A0030), const Color(0xFF3D0060)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD500F9).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFD500F9), size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '👑 Buka Admin Panel',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: const Color(0xFFD500F9),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFFD500F9), size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
                if (WS.userRole != 'superadmin') ...[
                  Divider(height: 1, color: WC.border),
                  _buildSettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Keluar Warung',
                    textColor: WC.primary,
                    iconColor: WC.primary,
                    onTap: _showLogoutConfirmation,
                  ),
                ] else ...[
                  Divider(height: 1, color: WC.border),
                  _buildSettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Keluar Warung',
                    textColor: WC.primary,
                    iconColor: WC.primary,
                    onTap: _showLogoutConfirmation,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ScaleButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? WC.textMid, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: textColor ?? WC.textDark,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textColor ?? WC.textLight, size: 18),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: WC.bg,
        title: Row(
          children: const [
            Text('🍵', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Teh Erni Bilang...'),
          ],
        ),
        content: Text(
          'Yakin mau cabut, Bestie? Kopi & Respect lo masih banyak lho. Yakin ga mau nongkrong lagi? ☕🥺',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: WC.textDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: Text(
              'Gak Jadi, Ngopi Lagi ☕',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: WC.textMid,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              WS.logout(); // Reset session
              Navigator.pop(dCtx); // close dialog
              Navigator.pushNamedAndRemoveUntil(context, Routes.splash, (route) => false);
            },
            child: Text(
              'Cabut Warung 🚪',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: WC.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

