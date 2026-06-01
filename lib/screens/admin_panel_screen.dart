import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/services/firebase_service.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/warung_state.dart';

// ============================================================
// 🔐 ADMIN PANEL — Warung Circle Superadmin Control Center
// ============================================================
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final FirebaseService _svc = FirebaseService();

  // Mock counters (replace with real Firestore queries when Firebase is live)
  int totalUsers = 128;
  int totalPosts = 342;
  int totalReports = 7;

  // Search query for users
  String _userSearch = '';
  final TextEditingController _searchCtrl = TextEditingController();

  // Teh Erni mood toggle
  String _tehErniMood = 'Sassy & Nyinyir 😏';
  final List<String> _tehErniMoods = [
    'Sassy & Nyinyir 😏',
    'Bijak & Kalem 🧘',
    'Hype & Semangat 🔥',
    'Galau & Puitis 😔',
    'Lucu & Baper 😂',
  ];

  // --- Mock Data ---
  final List<Map<String, dynamic>> _mockUsers = [
    {'name': 'Rara Setiawati', 'email': 'rara@warung.com', 'contact': '08111222333', 'role': 'user', 'kopi': 45.0, 'isBanned': false},
    {'name': 'Pak RT', 'email': 'pakrt@warung.com', 'contact': '08222333444', 'role': 'admin', 'kopi': 120.0, 'isBanned': false},
    {'name': 'Dika Pratama', 'email': 'dika@warung.com', 'contact': '08333444555', 'role': 'user', 'kopi': 30.0, 'isBanned': false},
    {'name': 'Siti Nuraini', 'email': 'siti@warung.com', 'contact': '08444555666', 'role': 'user', 'kopi': 12.0, 'isBanned': true},
    {'name': 'Budi Santoso', 'email': 'budi@warung.com', 'contact': '08555666777', 'role': 'user', 'kopi': 78.0, 'isBanned': false},
  ];

  final List<Map<String, dynamic>> _mockPosts = [
    {'id': 'post_1', 'author': 'Rara Setiawati', 'text': 'Habis kena tipu online shop...', 'comments': 12, 'likes': 24, 'isHot': true, 'time': '5 menit lalu'},
    {'id': 'post_2', 'author': 'Pak RT', 'text': 'Bubur diaduk VS bubur tidak diaduk...', 'comments': 85, 'likes': 230, 'isHot': true, 'time': '3 jam lalu'},
    {'id': 'post_3', 'author': 'Dika Pratama', 'text': 'Kopi latte kelapa hari ini JUARA!', 'comments': 4, 'likes': 18, 'isHot': false, 'time': '23 menit lalu'},
    {'id': 'post_4', 'author': 'Siti Nuraini', 'text': 'Gila sih, ternyata cowok gue kembar...', 'comments': 56, 'likes': 142, 'isHot': true, 'time': '1 jam lalu'},
    {'id': 'post_5', 'author': 'Budi Santoso', 'text': 'Lapak baru buka di RT05, ayoo!', 'comments': 2, 'likes': 7, 'isHot': false, 'time': '2 jam lalu'},
  ];

  final List<Map<String, dynamic>> _mockReports = [
    {'id': 'rpt_1', 'reporter': 'Dika Pratama', 'postAuthor': 'Unknown User', 'postText': 'Kata-kata kasar di komentar...', 'reason': 'Toxic / NSFW', 'time': '10 menit lalu'},
    {'id': 'rpt_2', 'reporter': 'Siti Nuraini', 'postAuthor': 'Budi Santoso', 'postText': 'Spam promosi produk palsu...', 'reason': 'Spam / Scam', 'time': '1 jam lalu'},
    {'id': 'rpt_3', 'reporter': 'Pak RT', 'postAuthor': 'Rara Setiawati', 'postText': 'Informasi hoaks tentang vaksin...', 'reason': 'Hoaks / Misinformasi', 'time': '2 jam lalu'},
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    if (_userSearch.isEmpty) return _mockUsers;
    return _mockUsers.where((u) =>
      u['name'].toString().toLowerCase().contains(_userSearch.toLowerCase()) ||
      u['email'].toString().toLowerCase().contains(_userSearch.toLowerCase()) ||
      u['contact'].toString().contains(_userSearch)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);

    // Auto-fill and search target user from URL query parameters (Superadmin WA Deep Link)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('target')) {
        final target = uri.queryParameters['target'] ?? '';
        if (target.isNotEmpty) {
          setState(() {
            _userSearch = target;
            _searchCtrl.text = target;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: _accent,
              content: Text(
                '🔍 Pintasan deteksi warga: $target. Silakan klik +Kopi untuk mengisi! ☕',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─── COLOR PALETTE (Cyberpunk Admin) ─────────────────────
  static const _bg = Color(0xFF0A0015);
  static const _surface = Color(0xFF130025);
  static const _accent = Color(0xFFD500F9); // purple
  static const _accentGreen = Color(0xFF39FF14);
  static const _accentRed = Color(0xFFFF1744);
  static const _accentBlue = Color(0xFF00E5FF);
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xAAFFFFFF);
  static const _cardBorder = Color(0x22FFFFFF);

  // ─── GUARD: Block non-superadmin ─────────────────────────
  @override
  Widget build(BuildContext context) {
    if (WS.userRole != 'superadmin') {
      return _buildAccessDenied();
    }
    return _buildAdminPanel();
  }

  // ─── ACCESS DENIED ────────────────────────────────────────
  Widget _buildAccessDenied() {
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🚫', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Akses Ditolak!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: _accentRed,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Panel ini hanya untuk Superadmin.\nHubungi Teh Erni kalau lo mau akses. 😏',
              style: GoogleFonts.nunito(fontSize: 14, color: _textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: _accent),
              child: Text('Balik ke Warung 🍵', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── MAIN ADMIN PANEL ────────────────────────────────────
  Widget _buildAdminPanel() {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildDashboardStats(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildUsersTab(),
                _buildPostsTab(),
                _buildReportsTab(),
                _buildAIControlTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _accent, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('👑', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Panel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                'Warung Circle Control Center',
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  color: _accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accent),
          ),
          child: Text(
            'SUPERADMIN',
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: _accent,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _accent.withOpacity(0.2)),
      ),
    );
  }

  // ─── DASHBOARD STATS STRIP ───────────────────────────────
  Widget _buildDashboardStats() {
    return Container(
      color: _surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildStatChip('👥 Warga', '$totalUsers', _accentBlue),
          const SizedBox(width: 10),
          _buildStatChip('📝 Post', '$totalPosts', _accentGreen),
          const SizedBox(width: 10),
          _buildStatChip('🚨 Laporan', '$totalReports', totalReports > 0 ? _accentRed : _accentGreen),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.nunito(fontSize: 10, color: color, fontWeight: FontWeight.w800)),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ─── TAB BAR ──────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: _surface,
      child: TabBar(
        controller: _tabCtrl,
        indicatorColor: _accent,
        indicatorWeight: 2.5,
        labelColor: _accent,
        unselectedLabelColor: _textSecondary,
        labelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.people_rounded, size: 18), text: 'Warga'),
          Tab(icon: Icon(Icons.article_rounded, size: 18), text: 'Post'),
          Tab(icon: Icon(Icons.report_rounded, size: 18), text: 'Laporan'),
          Tab(icon: Icon(Icons.smart_toy_rounded, size: 18), text: 'AI'),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TAB 1: USER MANAGEMENT
  // ════════════════════════════════════════════════════════════
  Widget _buildUsersTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.nunito(color: Colors.white, fontSize: 13),
            onChanged: (v) => setState(() => _userSearch = v),
            decoration: InputDecoration(
              hintText: 'Cari warga (nama, email, kontak)...',
              hintStyle: GoogleFonts.nunito(fontSize: 12, color: Colors.white38),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38, size: 18),
              suffixIcon: _userSearch.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: Colors.white38, size: 16),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _userSearch = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: _surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _accent.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _accent.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _accent, width: 1.5),
              ),
            ),
          ),
        ),
        // User count label
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_filteredUsers.length} Warga Ditemukan',
              style: GoogleFonts.poppins(fontSize: 11, color: _textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // List
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmpty('Warga tidak ditemukan 🔍')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (ctx, i) => _buildUserCard(_filteredUsers[i], i),
                ),
        ),
      ],
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    final isBanned = user['isBanned'] as bool;
    final kopi = (user['kopi'] as double);
    final role = user['role'] as String;
    final roleColor = role == 'superadmin'
        ? _accent
        : role == 'admin'
            ? _accentBlue
            : Colors.white54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isBanned ? _accentRed.withOpacity(0.5) : _cardBorder,
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isBanned ? _accentRed.withOpacity(0.2) : _accent.withOpacity(0.15),
                  child: Text(
                    user['name'].toString()[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isBanned ? _accentRed : _accent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user['name'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildRoleBadge(role, roleColor),
                          if (isBanned) ...[
                            const SizedBox(width: 4),
                            _buildBadge('BANNED', _accentRed),
                          ],
                        ],
                      ),
                      Text(
                        user['email'] as String,
                        style: GoogleFonts.nunito(fontSize: 10, color: Colors.white54),
                      ),
                      Text(
                        '☕ ${kopi.toInt()} Kopi  •  ${user['contact']}',
                        style: GoogleFonts.nunito(fontSize: 10, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _buildActionBtn(
                  icon: Icons.add_circle_rounded,
                  label: '+Kopi',
                  color: _accentGreen,
                  onTap: () => _showKopiDialog(user, true),
                ),
                const SizedBox(width: 6),
                _buildActionBtn(
                  icon: Icons.remove_circle_rounded,
                  label: '-Kopi',
                  color: _accentBlue,
                  onTap: () => _showKopiDialog(user, false),
                ),
                const SizedBox(width: 6),
                _buildActionBtn(
                  icon: isBanned ? Icons.lock_open_rounded : Icons.block_rounded,
                  label: isBanned ? 'Unban' : 'Ban',
                  color: isBanned ? _accentGreen : _accentRed,
                  onTap: () => _toggleBan(user, index),
                ),
                const SizedBox(width: 6),
                _buildActionBtn(
                  icon: Icons.delete_forever_rounded,
                  label: 'Hapus',
                  color: Colors.red.shade900,
                  onTap: () => _showDeleteUserDialog(user, index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TAB 2: POST MANAGEMENT
  // ════════════════════════════════════════════════════════════
  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _mockPosts.length,
      itemBuilder: (ctx, i) => _buildPostCard(_mockPosts[i], i),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final isHot = post['isHot'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isHot ? _accentRed.withOpacity(0.4) : _cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: _accent.withOpacity(0.15),
                      child: Text(
                        post['author'].toString()[0],
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w900, color: _accent),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        post['author'] as String,
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    if (isHot)
                      _buildBadge('🔥 HOT', _accentRed),
                    const SizedBox(width: 6),
                    Text(
                      post['time'] as String,
                      style: GoogleFonts.nunito(fontSize: 9, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post['text'] as String,
                  style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, size: 12, color: Colors.white30),
                    const SizedBox(width: 3),
                    Text('${post['likes']}', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white30)),
                    const SizedBox(width: 10),
                    const Icon(Icons.chat_bubble_rounded, size: 12, color: Colors.white30),
                    const SizedBox(width: 3),
                    Text('${post['comments']}', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white30)),
                  ],
                ),
              ],
            ),
          ),
          // Post Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _buildActionBtn(
                  icon: isHot ? Icons.local_fire_department_rounded : Icons.whatshot_outlined,
                  label: isHot ? 'Unmark Hot' : 'Mark Hot',
                  color: _accentRed,
                  onTap: () {
                    setState(() => post['isHot'] = !isHot);
                    _showSnack(
                      isHot ? '❄️ Post sudah di-unmark dari Hot' : '🔥 Post ditandai sebagai HOT!',
                      isHot ? _accentBlue : _accentRed,
                    );
                  },
                ),
                const SizedBox(width: 8),
                _buildActionBtn(
                  icon: Icons.delete_outline_rounded,
                  label: 'Hapus Post',
                  color: Colors.red.shade700,
                  onTap: () => _showDeletePostDialog(post, index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TAB 3: REPORTS
  // ════════════════════════════════════════════════════════════
  Widget _buildReportsTab() {
    if (_mockReports.isEmpty) {
      return _buildEmpty('Tidak ada laporan aktif 🎉\nWarkop aman dan tentram!');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _mockReports.length,
      itemBuilder: (ctx, i) => _buildReportCard(_mockReports[i], i),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accentRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _accentRed.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF1744), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    report['reason'] as String,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: _accentRed),
                  ),
                ),
                Text(report['time'] as String, style: GoogleFonts.nunito(fontSize: 9, color: Colors.white38)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReportRow('Pelapor', report['reporter'] as String, Icons.person_rounded),
                const SizedBox(height: 6),
                _buildReportRow('Terlapor', report['postAuthor'] as String, Icons.person_off_rounded),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    '"${report['postText']}"',
                    style: GoogleFonts.nunito(fontSize: 12, color: Colors.white60, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          // Report Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _buildActionBtn(
                  icon: Icons.check_circle_rounded,
                  label: 'Abaikan',
                  color: Colors.green,
                  onTap: () {
                    setState(() => _mockReports.removeAt(index));
                    totalReports = _mockReports.length;
                    _showSnack('✅ Laporan diabaikan', Colors.green);
                  },
                ),
                const SizedBox(width: 6),
                _buildActionBtn(
                  icon: Icons.block_rounded,
                  label: 'Ban User',
                  color: _accentRed,
                  onTap: () {
                    setState(() => _mockReports.removeAt(index));
                    totalReports = _mockReports.length;
                    _showSnack('🚫 User di-ban via laporan!', _accentRed);
                  },
                ),
                const SizedBox(width: 6),
                _buildActionBtn(
                  icon: Icons.delete_forever_rounded,
                  label: 'Hapus Post',
                  color: Colors.red.shade900,
                  onTap: () {
                    setState(() => _mockReports.removeAt(index));
                    totalReports = _mockReports.length;
                    _showSnack('🗑️ Post dihapus via laporan!', Colors.orange);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white38),
        const SizedBox(width: 6),
        Text('$label: ', style: GoogleFonts.nunito(fontSize: 11, color: Colors.white38)),
        Text(value, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // TAB 4: AI CONTROL
  // ════════════════════════════════════════════════════════════
  Widget _buildAIControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teh Erni Mood Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accent.withOpacity(0.15), _surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text('🍵', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teh Erni AI',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          Text(
                            'Mode aktif: $_tehErniMood',
                            style: GoogleFonts.nunito(fontSize: 11, color: _accent, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Pilih Mood Teh Erni:',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ..._tehErniMoods.map((mood) {
                  final isSelected = mood == _tehErniMood;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _tehErniMood = mood);
                      _showSnack('✅ Teh Erni sekarang dalam mode: $mood', _accent);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? _accent.withOpacity(0.2) : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? _accent : Colors.white12,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                            color: isSelected ? _accent : Colors.white30,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            mood,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.white60,
                            ),
                          ),
                          if (isSelected) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _accent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text('AKTIF', style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Stats Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentGreen.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.auto_graph_rounded, color: Color(0xFF39FF14), size: 18),
                  const SizedBox(width: 8),
                  Text('Status Sistem AI', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                const SizedBox(height: 14),
                _buildStatusRow('🤖 Teh Erni Engine', 'Aktif', _accentGreen),
                const SizedBox(height: 8),
                _buildStatusRow('🛡️ Filter Konten AI', 'Aktif', _accentGreen),
                const SizedBox(height: 8),
                _buildStatusRow('⚡ Auto-Reply Mode', 'Aktif (25% chance)', _accentBlue),
                const SizedBox(height: 8),
                _buildStatusRow('🔥 Hot Thread Detector', 'Aktif (>10 likes / >5 komen)', _accentRed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.nunito(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w700)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Text(value, style: GoogleFonts.poppins(fontSize: 9, color: color, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  // ─── SHARED HELPER WIDGETS ────────────────────────────────
  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w800, color: color), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(role.toUpperCase(), style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.w900, color: color)),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.w900, color: color)),
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😌', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(msg, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ─── DIALOGS ──────────────────────────────────────────────
  void _showKopiDialog(Map<String, dynamic> user, bool isAdd) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF130025),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Text(isAdd ? '☕' : '💸', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(isAdd ? 'Tambah Kopi' : 'Kurangi Kopi',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Warga: ${user['name']}',
                style: GoogleFonts.nunito(color: Colors.white60, fontSize: 13)),
            Text('Kopi Sekarang: ${(user['kopi'] as double).toInt()} ☕',
                style: GoogleFonts.nunito(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Jumlah Kopi...',
                hintStyle: GoogleFonts.nunito(color: Colors.white38, fontSize: 13),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: _accent.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: _accent.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _accent, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batalkan', style: GoogleFonts.poppins(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(ctrl.text.trim()) ?? 0;
              if (amount <= 0) return;
              Navigator.pop(ctx);
              try {
                if (isAdd) {
                  await _svc.addKopi(user['contact'] as String, amount);
                  setState(() => user['kopi'] = (user['kopi'] as double) + amount);
                } else {
                  setState(() => user['kopi'] = ((user['kopi'] as double) - amount).clamp(0, double.infinity));
                }
                _showSnack(
                  isAdd
                      ? '✅ +${amount.toInt()} Kopi ditambah ke ${user['name']}'
                      : '☕ -${amount.toInt()} Kopi dikurangi dari ${user['name']}',
                  isAdd ? _accentGreen : _accentBlue,
                );
              } catch (e) {
                _showSnack('❌ Gagal: $e', _accentRed);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdd ? _accentGreen : _accentBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isAdd ? 'Tambah ☕' : 'Kurangi 💸',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleBan(Map<String, dynamic> user, int index) {
    final isBanned = user['isBanned'] as bool;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF130025),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Text(isBanned ? '✅' : '🚫', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(isBanned ? 'Unban User?' : 'Ban User?',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        content: Text(
          isBanned
              ? 'Buka akses "${user['name']}" kembali ke Meja Warung?'
              : 'Ban "${user['name']}" dari seluruh aktivitas Meja Warung?',
          style: GoogleFonts.nunito(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batalkan', style: GoogleFonts.poppins(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                if (!isBanned) {
                  await _svc.banUser(user['contact'] as String);
                }
                setState(() => user['isBanned'] = !isBanned);
                _showSnack(
                  isBanned ? '✅ ${user['name']} berhasil di-unban!' : '🚫 ${user['name']} berhasil di-ban!',
                  isBanned ? _accentGreen : _accentRed,
                );
              } catch (e) {
                _showSnack('❌ Gagal: $e', _accentRed);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? _accentGreen : _accentRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isBanned ? 'Unban ✅' : 'Ban 🚫',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF130025),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Text('🗑️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text('Hapus Akun?', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        content: Text(
          'Hapus akun "${user['name']}" secara permanen dari Meja Warung? Aksi ini tidak dapat dibatalkan!',
          style: GoogleFonts.nunito(color: Colors.red.shade200, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batalkan', style: GoogleFonts.poppins(color: Colors.white38))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _mockUsers.removeAt(_mockUsers.indexOf(user));
                totalUsers = _mockUsers.length;
              });
              _showSnack('🗑️ Akun "${user['name']}" dihapus!', _accentRed);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Hapus Permanen 🗑️', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeletePostDialog(Map<String, dynamic> post, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF130025),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Text('🗑️', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text('Hapus Post?', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        ]),
        content: Text(
          'Hapus post dari "${post['author']}"?\n"${post['text']}"',
          style: GoogleFonts.nunito(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batalkan', style: GoogleFonts.poppins(color: Colors.white38))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _svc.deletePost(post['id'] as String);
                setState(() => _mockPosts.removeAt(index));
                totalPosts = _mockPosts.length + 340; // approximate total
                _showSnack('🗑️ Post berhasil dihapus!', _accentRed);
              } catch (e) {
                _showSnack('❌ Gagal: $e', _accentRed);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Hapus 🗑️', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
