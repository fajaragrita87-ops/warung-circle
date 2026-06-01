import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/utils/constants.dart';
import 'package:warung_circle/utils/warung_state.dart';
import 'package:warung_circle/widgets/cute_card.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';
import 'package:warung_circle/utils/file_picker_helper.dart';
import 'package:warung_circle/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final List<Map<String, dynamic>> globalPosts = [
    {
      'author': 'Rara Setiawati',
      'character': 'Teh Erni',
      'time': '5 menit lalu',
      'bg': const Color(0xFFFFECEF), // soft red for sad
      'emoji': '😔',
      'mood': '😔 Sedih',
      'moodLabel': 'Lagi sedih banget',
      'text': 'Habis kena tipu online shop, rugi 200rb 😭 Pak RT tolong patroli dong yang lebih ketat!',
      'reactions': {'🤗': 24, '💪': 18, '🧠': 12, '🔥': 31},
      'comments': 2,
      'tags': ['#CurhatBaper'],
      'commentList': [
        {'author': 'Pak RT', 'text': 'Kasbon mulu sih rar 😂', 'time': '5 menit lalu', 'isAbsen1': true},
        {'author': 'Teh Erni', 'text': 'Sabar ya bestie, badai pasti berlalu! 🍵', 'time': '4 menit lalu', 'isAbsen1': false},
      ],
    },
    {
      'author': 'Pak RT',
      'character': 'Pak RT',
      'time': '3 jam lalu',
      'bg': const Color(0xFFFFFBE6), // soft yellow
      'emoji': '🍲',
      'mood': '😵 Bingung',
      'moodLabel': 'Lagi bingung',
      'text': 'Bubur diaduk VS bubur tidak diaduk. Sekte mana yang paling benar? Mari kita selesaikan secara adat! 🍲',
      'reactions': {'🤗': 12, '💪': 8, '🧠': 5, '🔥': 85},
      'comments': 2,
      'tags': ['#Kongkow'],
      'isVsMode': true,
      'choiceA': '🥣 Sekte Diaduk',
      'choiceB': '❌ Sekte Pisah',
      'votesA': 152,
      'votesB': 94,
      'commentList': [
        {'author': 'Hansip', 'text': 'Diaduk lah Pak RT, lebih menyatu rasanya! 🥣', 'time': '2 jam lalu', 'isAbsen1': true},
        {'author': 'Teh Erni', 'text': 'Sekte pisah emang ga ada tandingannya, rapi! 😂', 'time': '1 jam lalu', 'isAbsen1': false},
      ],
    },
    {
      'author': 'Dika Pratama',
      'character': 'Abang Lapak',
      'time': '23 menit lalu',
      'bg': const Color(0xFFE8F1FF), // soft blue for happy
      'emoji': '😄',
      'mood': '😄 Senang',
      'moodLabel': 'Lagi senang',
      'text': 'Kopi latte kelapa hari ini JUARA banget di Dapur Erni! Rekomendasi nongkrong siang ini ngab ☕🥥',
      'imageUrl': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=600',
      'location': 'Dapur Erni ☕',
      'reactions': {'🤗': 8, '💪': 42, '🧠': 15, '🔥': 56},
      'comments': 2,
      'tags': ['#SkillSwap'],
      'commentList': [
        {'author': 'Budi Santoso', 'text': 'Mantap ngab, ntar sore otw cobain! 🚀', 'time': '15 menit lalu', 'isAbsen1': true},
        {'author': 'Teh Erni', 'text': 'Awas tagihan kasbon kopi kamu ya dik! 🍵👀', 'time': '10 menit lalu', 'isAbsen1': false},
      ],
    },
    {
      'author': 'Siti Nuraini',
      'character': 'Kucing',
      'time': '1 jam lalu',
      'bg': const Color(0xFFFFECEF), // soft coral
      'emoji': '😭',
      'mood': '😔 Sedih',
      'moodLabel': 'Lagi sedih banget',
      'text': 'Gila sih, ternyata cowok gue kembar dan yang jalan sama gue selama ini adalah adiknya... [Bersambung Part 1]',
      'reactions': {'🤗': 54, '💪': 24, '🧠': 18, '🔥': 96},
      'comments': 2,
      'tags': ['#CurhatBaper'],
      'isContinued': true,
      'commentList': [
        {'author': 'Rara Setiawati', 'text': 'Plot twist terseram tahun ini sis! 😱', 'time': '45 menit lalu', 'isAbsen1': true},
        {'author': 'Ustad', 'text': 'Sabar mbak, musyawarah kekeluargaan dulu ya 🙏', 'time': '30 menit lalu', 'isAbsen1': false},
      ],
    },
    {
      'author': 'Siti Nuraini',
      'character': 'Kucing',
      'time': '1 jam lalu',
      'bg': const Color(0xFFFFFBE6), // soft yellow for confused
      'emoji': '😵',
      'mood': '😵 Bingung',
      'moodLabel': 'Lagi bingung',
      'text': 'Teh Erni AI jawab curhat gue lebih bijak dari mantan. Drama percintaan hari ini: resolved 😂',
      'reactions': {'🤗': 34, '💪': 12, '🧠': 45, '🔥': 28},
      'comments': 1,
      'tags': ['#TitipCerita'],
      'commentList': [
        {'author': 'Teh Erni', 'text': 'Kan udah dibilang, mantan tuh buang ke tong sampah aja bestie 😏', 'time': '50 menit lalu', 'isAbsen1': true},
      ],
    },
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _currentUserMood = '😄 Senang';
  String _selectedTag = 'Semua';
  String _selectedFeedTab = '🔥 Lagi Panas';
  bool _showAiReminder = false;
  String _aiReminderText = 'Lagi nyari apa sih Ngab? Curhat aja sini ke Teh Erni, jangan dipendem sendiri, Bestie 😏';

  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _streamedPosts = [];
  StreamSubscription<List<Map<String, dynamic>>>? _postsSub;

  List<Map<String, dynamic>> get _posts => _streamedPosts.isNotEmpty ? _streamedPosts : WS.dynamicPosts;

  // Mascot quotes & bubble state
  bool _showMascotBubble = false;
  int _mascotQuoteIndex = 0;
  final List<String> _mascotQuotes = [
    'Mau nongkrong di mana hari ini? ☕',
    'Curhat sini aja, santai 😏',
    'Cari temen nongkrong yuk! 👥',
    'Lama ga keliatan, kemana aja? 😏',
    'Ada cerita baru di Meja Warung tuh!',
    'Curhat sini, ga usah jaim! 🍵',
    'Warung lagi rame nih, buruan nimbrung!',
  ];
  Timer? _quoteTimer;
  Offset _mascotOffset = const Offset(0, 0);

  // Feed expansion state
  bool _isFeedExpanded = false;

  // Animations
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  final List<String> _moods = ['😄 Senang', '😔 Sedih', '😡 Kesel', '😵 Bingung'];
  final List<String> _tags = ['Semua', '#CurhatBaper', '#SkillSwap', '#LapakWarung', '#Kongkow', '#PakRT'];



  final List<Map<String, String>> _stories = [
    {'name': 'Teh Erni', 'character': 'Teh Erni', 'label': 'Live!'},
    {'name': 'Pak RT', 'character': 'Pak RT', 'label': 'Patroli'},
    {'name': 'Ustad', 'character': 'Ustad', 'label': 'Kajian'},
    {'name': 'Abang L.', 'character': 'Abang Lapak', 'label': 'Lapak'},
    {'name': 'Kucing', 'character': 'Kucing', 'label': 'Santai'},
  ];

  @override
  void initState() {
    WS.init(HomeScreen.globalPosts);
    super.initState();

    // Loop float animation
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // === REAL-TIME FEED STREAM (Firebase or Mock) ===
    _postsSub = _firebaseService.streamPosts().listen((posts) {
      if (mounted) {
        setState(() {
          _streamedPosts = posts;
        });
      }
    });

    // AI scroll/habit reminder after 15 seconds
    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _showAiReminder = true;
        });
      }
    });

    // Mascot starts with speech bubble hidden, only shown on click

    _quoteTimer = Timer.periodic(const Duration(seconds: 8), (t) {
      if (mounted) {
        setState(() {
          _mascotQuoteIndex = (_mascotQuoteIndex + 1) % _mascotQuotes.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _quoteTimer?.cancel();
    _postsSub?.cancel();
    super.dispose();
  }

  // === SAFETY FILTER: Kata Sensitif / NSFW / Toxic ===
  static const List<String> _bannedWords = [
    'bangsat', 'brengsek', 'bajingan', 'keparat', 'goblok', 'tolol',
    'bego', 'idiot', 'bodoh', 'kampret', 'kontol', 'memek', 'ngentot',
    'jancok', 'asu', 'anjing', 'bangke', 'bitch', 'fuck', 'shit',
    'asshole', 'cunt', 'bastard', 'damn', 'hell',
  ];

  bool _containsBannedWords(String text) {
    final lower = text.toLowerCase();
    return _bannedWords.any((word) => lower.contains(word));
  }

  // Filter posts based on selected category tag
  List<Map<String, dynamic>> get _filteredPosts {
    if (_selectedTag == 'Semua') return _posts;
    return _posts.where((p) {
      final tagsList = p['tags'] as List<String>;
      return tagsList.contains(_selectedTag);
    }).toList();
  }

  // Check if a post qualifies as a HOT THREAD
  static bool isHotThread(Map<String, dynamic> post) {
    final likes = (post['likes'] as num?)?.toInt() ?? 0;
    final comments = (post['commentsCount'] as num?)?.toInt()
        ?? (post['comments'] is int ? (post['comments'] as int) : 0)
        ?? (post['commentList'] is List ? (post['commentList'] as List).length : 0);
    return likes > 10 || comments > 5;
  }

  // Prioritize showing similar mood posts to the user and sort based on active tab
  List<Map<String, dynamic>> get _prioritizedPosts {
    final filtered = List<Map<String, dynamic>>.from(_filteredPosts);
    if (_selectedFeedTab == '🔥 Lagi Panas') {
      filtered.sort((a, b) {
        final likesA = (a['likes'] as num?)?.toInt() ?? 0;
        final likesB = (b['likes'] as num?)?.toInt() ?? 0;
        final commentsA = (a['commentsCount'] as num?)?.toInt()
            ?? (a['comments'] is int ? a['comments'] as int : 0);
        final commentsB = (b['commentsCount'] as num?)?.toInt()
            ?? (b['comments'] is int ? b['comments'] as int : 0);
        final scoreA = (a['isVsMode'] == true ? 500 : 0) + commentsA * 10 + likesA * 5
            + (a['reactions']?.values?.fold(0, (dynamic prev, dynamic e) => prev + e) ?? 0);
        final scoreB = (b['isVsMode'] == true ? 500 : 0) + commentsB * 10 + likesB * 5
            + (b['reactions']?.values?.fold(0, (dynamic prev, dynamic e) => prev + e) ?? 0);
        return scoreB.compareTo(scoreA); // popular first
      });
      final matching = filtered.where((p) => p['mood'] == _currentUserMood).toList();
      final nonMatching = filtered.where((p) => p['mood'] != _currentUserMood).toList();
      return [...matching, ...nonMatching];
    } else {
      return filtered; // purely chronological for "👀 Baru Aja Dipost"
    }
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '🏠 Posko Utama',
      currentIndex: 0,
      // FAB taps open the post creation dialog
      onFabPressed: () => _showCreatePostDialog(),
      body: _DashboardBody(
        posts: _prioritizedPosts,
        stories: _stories,
        currentMood: _currentUserMood,
        selectedTag: _selectedTag,
        selectedFeedTab: _selectedFeedTab,
        tags: _tags,
        moods: _moods,
        onMoodChanged: (m) => setState(() => _currentUserMood = m),
        onTagChanged: (t) => setState(() => _selectedTag = t),
        onFeedTabChanged: (t) => setState(() => _selectedFeedTab = t),
        onCreatePost: () => _showCreatePostDialog(),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: FadeScaleIn(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, Bestie Nongkrong! 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: WC.textDark,
                    ),
                  ),
                  Text(
                    'Ada cerita gokil apa hari ini, Ngab? Curhat sini, ga usah jaim! 🍵',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WC.textMid,
                    ),
                  ),
                ],
              ),
            ),
            // QR Scan shortcut button
            ScaleButton(
              onTap: () => Navigator.pushNamed(context, Routes.scanWarung),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: WC.successLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: WC.success.withOpacity(0.4), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_scanner_rounded, size: 20, color: WC.success),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ScaleButton(
              onTap: () => Navigator.pushNamed(context, Routes.dapurErni),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: WC.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: WC.primary.withOpacity(0.3), width: 2),
                ),
                child: const Center(
                  child: Text('😊', style: TextStyle(fontSize: 22)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === FEATURE HUB: Viral Features Discovery Section ===
  Widget _buildFeatureHub() {
    final features = [
      {
        'label': 'Gosip\nWarung',
        'emoji': '📢',
        'color': WC.danger,
        'route': Routes.gosipWarung,
        'badge': 'LIVE',
      },
      {
        'label': 'Kapsul\nWarung',
        'emoji': '🎲',
        'color': WC.primary,
        'route': Routes.kapsulWarung,
        'badge': 'GACHA',
      },
      {
        'label': 'Lagi\nNgapain?',
        'emoji': '📸',
        'color': const Color(0xFFCC00CC),
        'route': Routes.lagiNgapain,
        'badge': 'NEW',
      },
      {
        'label': 'Lelang\nWaktu',
        'emoji': '⏰',
        'color': WC.warning,
        'route': Routes.lelangWaktu,
        'badge': 'HOT',
      },
      {
        'label': 'Scan\nWarung',
        'emoji': '📷',
        'color': WC.success,
        'route': Routes.scanWarung,
        'badge': '+Kopi',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fitur Viral Warung 🔥',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: WC.textDark,
                ),
              ),
              Text(
                'Semua Fitur',
                style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: WC.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: features.length,
              itemBuilder: (ctx, idx) {
                final f = features[idx];
                final color = f['color'] as Color;
                return Padding(
                  padding: EdgeInsets.only(right: idx < features.length - 1 ? 10 : 0),
                  child: ScaleButton(
                    onTap: () => Navigator.pushNamed(context, f['route'] as String),
                    child: Container(
                      width: 76,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            clipBehavior: Clip.none,
                            children: [
                              Text(f['emoji'] as String, style: const TextStyle(fontSize: 26)),
                              Positioned(
                                top: -5,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    f['badge'] as String,
                                    style: GoogleFonts.poppins(fontSize: 5, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            f['label'] as String,
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedPriorityTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prioritas Meja Warung ⚡',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: WC.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildPriorityTab('🔥 Lagi Panas'),
              const SizedBox(width: 10),
              _buildPriorityTab('👀 Baru Aja Dipost'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityTab(String tabName) {
    final isSelected = _selectedFeedTab == tabName;
    return ScaleButton(
      onTap: () {
        setState(() {
          _selectedFeedTab = tabName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? WC.primary : WC.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? Colors.transparent : WC.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: WC.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          tabName,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : WC.textMid,
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Warga Saat Ini 🎭',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: WC.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_moods.length, (i) {
              final m = _moods[i];
              final isSelected = m == _currentUserMood;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  // Slightly float individual emoji bubbles dynamically!
                  child: AnimatedBuilder(
                    animation: _floatAnim,
                    builder: (context, child) {
                      final offset = _floatAnim.value * (i % 2 == 0 ? 1.0 : -0.8);
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: ScaleButton(
                      onTap: () => setState(() {
                        _currentUserMood = m;
                        // Reset list display expansion to make highlights work
                        _isFeedExpanded = false;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? WC.primary : WC.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.transparent : WC.border,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? WC.primary.withOpacity(0.24)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            m.split(' ')[0], // only emoji
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPostCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: CuteCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const NeonGlassPortrait(character: 'Abang Lapak', size: 38, animate: false),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ada cerita seru hari ini? ✍️',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: WC.textDark,
                    ),
                  ),
                  Text(
                    'Tulis cerita lo biar Meja Warung makin anget...',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: WC.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ScaleButton(
                  onTap: () => _showCreatePostDialog(startRecordingImmediately: true),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: WC.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: WC.primary.withOpacity(0.3), width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.mic_rounded, size: 18, color: WC.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                KopiButton(
                  label: 'Tulis Cerita',
                  onPressed: () => _showCreatePostDialog(),
                  fullWidth: false,
                  height: 36,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Warga Lagi Online 🟢',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: WC.textDark,
                ),
              ),
              Text(
                'Lihat Semua Warga',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: WC.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _stories.length,
            itemBuilder: (ctx, i) {
              final s = _stories[i];
              return FadeScaleIn(
                delay: Duration(milliseconds: 40 * i),
                child: _StoryItem(story: s),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Text(
            'Trending Cerita 🔥',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: WC.textDark,
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tags.length,
            itemBuilder: (ctx, i) {
              final active = _tags[i] == _selectedTag;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ScaleButton(
                  onTap: () => setState(() => _selectedTag = _tags[i]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? WC.primary : WC.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: active ? Colors.transparent : WC.border,
                      ),
                    ),
                    child: Text(
                      _tags[i],
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : WC.textMid,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isCurhatEmpty = _selectedTag == '#CurhatBaper' || _selectedTag == 'Semua' || _selectedTag.contains('Curhat');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: FadeScaleIn(
          child: Column(
            children: [
              const Text('🍵', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                isCurhatEmpty
                    ? 'Belum ada curhatan... lu duluan aja 😏'
                    : 'Belum nemu circle? Santai, kita cariin',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: WC.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Yuk, tulis cerita baru lo sekarang biar warung makin anget!',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: WC.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiReminderOverlay() {
    if (!_showAiReminder || MediaQuery.of(context).viewInsets.bottom > 0) return const SizedBox.shrink();
    return Positioned(
      bottom: 86,
      right: 16,
      left: 16,
      child: FadeScaleIn(
        child: Container(
          decoration: BoxDecoration(
            color: WC.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: WC.primary.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const NeonGlassPortrait(character: 'Teh Erni', size: 44, animate: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teh Erni AI 💅',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: WC.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _aiReminderText,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: WC.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  KopiButton(
                    label: 'Curhat! 🍵',
                    onPressed: () {
                      setState(() => _showAiReminder = false);
                      Navigator.pushNamed(context, Routes.titipCerita);
                    },
                    fullWidth: false,
                    height: 32,
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(() => _showAiReminder = false),
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: WC.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMascot() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 80 + _mascotOffset.dy,
      right: 4 + _mascotOffset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            double newDx = _mascotOffset.dx - details.delta.dx;
            double newDy = _mascotOffset.dy - details.delta.dy;
            _mascotOffset = Offset(
              newDx.clamp(-15.0, 350.0),
              newDy.clamp(-50.0, 500.0),
            );
          });
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            // Cyclical Speech Bubble from floating character (appears when clicked)
            if (_showMascotBubble)
              Positioned(
                bottom: 56,
                right: 0,
                child: FadeScaleIn(
                  duration: const Duration(milliseconds: 350),
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: WC.surface,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: const Radius.circular(0),
                      ),
                      border: Border.all(color: WC.primary.withOpacity(0.35), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            _mascotQuotes[_mascotQuoteIndex],
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: WC.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () => setState(() => _showMascotBubble = false),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: WC.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Draggable 48x48 rounded mascot bubble
            AnimatedBuilder(
              animation: _floatAnim,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -_floatAnim.value * 1.5),
                child: child,
              ),
              child: ScaleButton(
                onTap: () {
                  // Sassy quote rotation on tap
                  setState(() {
                    _mascotQuoteIndex = (_mascotQuoteIndex + 1) % _mascotQuotes.length;
                    _showMascotBubble = !_showMascotBubble;
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: WC.primary.withOpacity(0.8), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: WC.primary.withOpacity(0.24),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/images/teh_erni_transparent.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text('🍵', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog({bool startRecordingImmediately = false}) {
    final TextEditingController textCtrl = TextEditingController();
    final TextEditingController locationCtrl = TextEditingController();
    String selectedPostMood = '😄 Senang';
    String selectedPostTag = '#CurhatBaper';
    bool isAnonymous = false;

    // Photo selection state
    String? selectedPresetUrl;
    dynamic customImageBytes; // Uint8List?
    String? customImageName;

    final List<Map<String, String>> photoPresets = [
      {
        'name': 'Es Kopi Aesthetic ☕',
        'url': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=600'
      },
      {
        'name': 'Warung Cyber 🌃',
        'url': 'https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=600'
      },
      {
        'name': 'Kucing Imut 🐱',
        'url': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=600'
      },
      {
        'name': 'Gen Z Setup 💻',
        'url': 'https://images.unsplash.com/photo-1527689368864-3a821dbccc34?q=80&w=600'
      },
      {
        'name': 'Mie Warkop 🍜',
        'url': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=600'
      },
    ];

    // Voice note recording states
    bool isRecording = false;
    int secondsLeft = 5;
    Timer? recordingTimer;
    bool autoStartTriggered = false;

    // === FEATURE 4: BAPER SHIELD — Privacy Level Selector ===
    String privacyMode = 'Publik'; // Options: 'Publik', 'Cuma Circle', 'Anonim'

    void _showPresetPicker(StateSetter parentSetState) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: const BoxDecoration(
            color: WC.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Preset Aesthetic 🖼️',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: WC.textDark,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photoPresets.length,
                  itemBuilder: (context, idx) {
                    final preset = photoPresets[idx];
                    return GestureDetector(
                      onTap: () {
                        parentSetState(() {
                          selectedPresetUrl = preset['url'];
                          customImageBytes = null;
                          customImageName = null;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: WC.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(preset['url']!, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                  child: Text(
                                    preset['name']!,
                                    style: GoogleFonts.poppins(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    }

    void startRecording(StateSetter setModalState) {
      if (isRecording) return;
      setModalState(() {
        isRecording = true;
        secondsLeft = 5;
      });

      recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsLeft > 1) {
          setModalState(() {
            secondsLeft--;
          });
        } else {
          timer.cancel();
          // Generate a hilarious Gen Z voice note transcription
          final List<String> transcriptions = [
            "Gue lagi nongkrong di warkop nih, kopinya mantap tapi dompet tipis wkwk ☕😭",
            "Spill the tea dong, ada gosip baru apa hari ini di sirkel sebelah? 👀💅",
            "Teh Erni AI emang paling mantap, dapet bonus Kopi gratis langsung gas! 🚀🔥",
            "Capek bgt dengerin drama sirkel sebelah, mending mabar ML aja ga sih ngab? 🎮🤙",
            "Respect sepuh! Siapa nih yang absen 1 hari ini? Sini gue traktir kopi 🫡🟢",
          ];
          final randomText = transcriptions[DateTime.now().millisecond % transcriptions.length];

          setModalState(() {
            isRecording = false;
            textCtrl.text = randomText;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: WC.success,
              content: Row(
                children: const [
                  Text('🎙️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Voice note berhasil ditranskrip secara cerdas oleh Teh Erni AI! ✨',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          if (startRecordingImmediately && !autoStartTriggered) {
            autoStartTriggered = true;
            Future.delayed(const Duration(milliseconds: 300), () {
              startRecording(setModalState);
            });
          }

          return Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: WC.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
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
                    'Bagi Cerita di Meja Warung ✍️',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Text input
                  TextField(
                    controller: textCtrl,
                    maxLines: 4,
                    minLines: 2,
                    enabled: !isRecording,
                    decoration: InputDecoration(
                      hintText: isRecording
                          ? '🎙️ Merekam suara... Silakan bicara! ($secondsLeft detik tersisa)'
                          : 'Tulis cerita lo di sini, bebas nimbrung & curhat apa aja... ☕',
                      hintStyle: TextStyle(
                        color: isRecording ? WC.accent : null,
                        fontWeight: isRecording ? FontWeight.bold : null,
                      ),
                      suffixIcon: ScaleButton(
                        onTap: isRecording ? null : () => startRecording(setModalState),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isRecording ? WC.accent.withOpacity(0.12) : WC.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRecording ? Icons.settings_voice_rounded : Icons.mic_rounded,
                            color: isRecording ? WC.accent : WC.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category tag selector
                  Text(
                    'Kategori Tag 🏷️',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['#CurhatBaper', '#SkillSwap', '#LapakWarung'].map((t) {
                      final isSelected = t == selectedPostTag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setModalState(() => selectedPostTag = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? WC.primary : WC.surface,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : WC.border,
                              ),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : WC.textMid,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Mood selector
                  Text(
                    'Mood Cerita Lu Saat Ini 🎭',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _moods.map((m) {
                      final isSelected = m == selectedPostMood;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => setModalState(() => selectedPostMood = m),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? WC.primary : WC.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : WC.border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  m,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white : WC.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // === FEATURE 4: BAPER SHIELD PRIVACY SELECTOR ===
                  Text(
                    '🛡️ Baper Shield — Pilih Privasi Lo',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Publik', 'Cuma Circle', 'Anonim'].map((mode) {
                      final isSelected = mode == privacyMode;
                      Color modeColor;
                      String modeEmoji;
                      switch (mode) {
                        case 'Cuma Circle': modeColor = WC.secondary; modeEmoji = '👥'; break;
                        case 'Anonim': modeColor = WC.kucing; modeEmoji = '👻'; break;
                        default: modeColor = WC.success; modeEmoji = '🌐';
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setModalState(() => privacyMode = mode),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? modeColor : WC.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : WC.border,
                                ),
                                boxShadow: isSelected
                                    ? [BoxShadow(color: modeColor.withOpacity(0.25), blurRadius: 8)]
                                    : [],
                              ),
                              child: Column(
                                children: [
                                  Text(modeEmoji, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 3),
                                  Text(
                                    mode,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? Colors.white : WC.textMid,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Show whisper mode hint
                  if (privacyMode == 'Anonim') ...[  
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: WC.kucing.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: WC.kucing.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.visibility_off_rounded, size: 13, color: WC.kucing),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Mode Anonim: nama & avatar lo disembunyikan. Whisper mode aktif! 👻',
                              style: GoogleFonts.nunito(fontSize: 10, color: WC.kucing, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // === PHOTO ATTACHMENT SECTION ===
                  Text(
                    'Lampirkan Foto 📸',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (selectedPresetUrl == null && customImageBytes == null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ScaleButton(
                            scale: 0.96,
                            onTap: () => _showPresetPicker(setModalState),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: WC.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: WC.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image_rounded, size: 16, color: WC.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Galeri Preset 🖼️',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: WC.textMid,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ScaleButton(
                            scale: 0.96,
                            onTap: () async {
                              final bytes = await FilePickerHelper.pickImage();
                              if (bytes != null) {
                                setModalState(() {
                                  customImageBytes = bytes;
                                  customImageName = 'Custom_Upload.jpg';
                                  selectedPresetUrl = null;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: WC.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: WC.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.upload_file_rounded, size: 16, color: WC.accent),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Upload File 📁',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: WC.textMid,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Photo Preview Card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WC.primary.withOpacity(0.3)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: selectedPresetUrl != null
                                  ? Image.network(selectedPresetUrl!, fit: BoxFit.cover)
                                  : Image.memory(customImageBytes!, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: ScaleButton(
                                onTap: () {
                                  setModalState(() {
                                    selectedPresetUrl = null;
                                    customImageBytes = null;
                                    customImageName = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Location Input (Optional)
                  Text(
                    'Lokasi Nongkrong 📍 (Opsional)',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: WC.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tulis nama tempat, misal: Dapur Erni ☕',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  KopiButton(
                    label: 'Posting Cerita ke Meja Warung 🔥',
                    onPressed: () {
                      final text = textCtrl.text.trim();
                      if (text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Isi dulu ceritanya bro!')),
                        );
                        return;
                      }

                      // === SAFETY FILTER: Cek kata sensitif sebelum posting ===
                      if (_containsBannedWords(text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: WC.danger,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            content: Row(
                              children: const [
                                Text('👮‍♂️', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8),
                                Expanded(child: Text('Hansip: Stop! Kata-kata itu ga boleh di warkop ini bestie. Jaga etika ya! 🚨')),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      // Generate random avatar for anon
                      final anonAvatars = ['👻', '🤖', '🥷', '👾', '👽'];
                      final randomAvatar = anonAvatars[DateTime.now().millisecond % anonAvatars.length];

                      final newPost = {
                        'author': privacyMode == 'Anonim' 
                            ? 'Anonim 👻'
                            : privacyMode == 'Cuma Circle'
                                ? 'Warga Circle 👥'
                                : (WS.userName.isNotEmpty ? WS.userName : 'Sobat Warung'),
                        'character': privacyMode == 'Anonim' ? 'Kucing' : 'Teh Erni',
                        'time': 'Baru saja',
                        'bg': selectedPostMood == '😔 Sedih'
                            ? const Color(0xFFFFECEF)
                            : selectedPostMood == '😡 Kesel'
                                ? const Color(0xFFFFF3E0)
                                : selectedPostMood == '😵 Bingung'
                                    ? const Color(0xFFFFFBE6)
                                    : const Color(0xFFE8F8EF),
                        'emoji': selectedPostMood.split(' ')[0],
                        'mood': selectedPostMood,
                        'moodLabel': 'Lagi ${selectedPostMood.split(' ')[1]}',
                        'text': text,
                        'imageUrl': selectedPresetUrl,
                        'imageData': customImageBytes,
                        'location': locationCtrl.text.trim().isNotEmpty ? locationCtrl.text.trim() : null,
                        'reactions': {'🤗': 0, '💪': 0, '🧠': 0, '🔥': 0},
                        'comments': 0,
                        'tags': [selectedPostTag],
                        'commentList': <Map<String, dynamic>>[],
                      };

                      setState(() {
                        _posts.insert(0, newPost);
                        WS.kopiBalance += 10.0; // Bonus +10 Kopi riil!
                        _isFeedExpanded = true; // Auto-expand to show new post
                      });

                      Navigator.pop(ctx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: WC.success,
                          content: Row(
                            children: const [
                              Text('🎉', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              Text('Cerita lo nangkring di Meja Warung! Bonus +10 Kopi dikantongin ☕'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class _DashboardBody extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final List<Map<String, String>> stories;
  final String currentMood;
  final String selectedTag;
  final String selectedFeedTab;
  final List<String> tags;
  final List<String> moods;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onTagChanged;
  final ValueChanged<String> onFeedTabChanged;
  final VoidCallback onCreatePost;

  const _DashboardBody({
    super.key,
    required this.posts,
    required this.stories,
    required this.currentMood,
    required this.selectedTag,
    required this.selectedFeedTab,
    required this.tags,
    required this.moods,
    required this.onMoodChanged,
    required this.onTagChanged,
    required this.onFeedTabChanged,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        // 1. GREETING & QUICK ACTIONS
        _buildGreetingSection(context),
        const SizedBox(height: 28),

        // 2. INTERACTIVE MOOD SECTION
        _buildMoodSection(context),
        const SizedBox(height: 30),

        // 3. VIRAL FEATURES QUICK MENU
        _buildQuickMenu(context),
        const SizedBox(height: 30),

        // 4. HERO SECTION: BeReal-style "Lagi Ngapain?"
        _buildHeroBeReal(context),
        const SizedBox(height: 30),

        // 5. ACTION SECTION: "Butuh Bantuan?" (Skill Swap)
        _buildSkillSwapCard(context),
        const SizedBox(height: 32),

        // 6. HOT THREADS SECTION (Horizontal Scroll)
        _buildHotThreads(context),
        const SizedBox(height: 32),

        // 7. FEED HEADER (Tabs + Tags Filter)
        _buildFeedHeader(context),
        const SizedBox(height: 18),

        // 8. VERTICAL FEED LIST
        _buildFeedList(context),
      ],
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const CyberIcon('waving_hand', size: 24, color: Color(0xFF00FFFF), glowing: true),
              const SizedBox(width: 10),
              Text(
                WS.isLoggedIn ? 'Halo, ${WS.userName}!' : 'Halo, Rara!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // QR Scan shortcut button (Glassmorphic)
        ScaleButton(
          onTap: () => Navigator.pushNamed(context, Routes.scanWarung),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x15FFFFFF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x20FFFFFF), width: 1.5),
            ),
            child: const Center(
              child: CyberIcon('qr', size: 18, color: Color(0xFF00FFFF)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ScaleButton(
          onTap: () => Navigator.pushNamed(context, Routes.dapurErni),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x15FFFFFF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x20FFFFFF), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFFFF007F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSection(BuildContext context) {
    final moodSassyText = {
      '😄 Senang': 'Seneng terus, dapet durian runtuh ya Ngab? 😂',
      '😔 Sedih': 'Sedih amat bestie... Sini cerita, kita seduh kopi bareng ☕',
      '😡 Kesel': 'Sabar sepuh, emosi bikin cepet tua. Tabrak aja kalo berani wkwk 😤',
      '😵 Bingung': 'Pusing mikirin masa depan apa mikirin mantan nih? 🤪',
    };

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lagi ngerasa apa hari ini? 🤔',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((m) {
              final isSelected = m == currentMood;
              final label = m.split(' ')[1];
              
              String iconKey;
              Color iconColor;
              switch (m) {
                case '😄 Senang': iconKey = 'smile'; iconColor = const Color(0xFF39FF14); break;
                case '😔 Sedih': iconKey = 'sad'; iconColor = const Color(0xFF00FFFF); break;
                case '😡 Kesel': iconKey = 'angry'; iconColor = const Color(0xFFFF007F); break;
                default: iconKey = 'brain'; iconColor = const Color(0xFF8D32FF);
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ScaleButton(
                    scale: 0.95,
                    onTap: () => onMoodChanged(m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? iconColor.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? iconColor : const Color(0x1AFFFFFF),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: iconColor.withOpacity(0.25),
                                  blurRadius: 12,
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          CyberIcon(
                            iconKey,
                            size: 26,
                            color: isSelected ? iconColor : Colors.white60,
                            glowing: isSelected,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x10FFFFFF)),
            ),
            width: double.infinity,
            child: Text(
              moodSassyText[currentMood] ?? 'Curhat aja bestie nongkrong! 🍵',
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenu(BuildContext context) {
    final menuItems = [
      {'name': 'Gacha Kapsul', 'emoji': 'casino', 'route': Routes.kapsulWarung, 'color': const Color(0x12FF007F), 'txtColor': const Color(0xFFFF007F)},
      {'name': 'Gosip AI', 'emoji': 'campaign', 'route': Routes.gosipWarung, 'color': const Color(0x1200FFFF), 'txtColor': const Color(0xFF00FFFF)},
      {'name': 'Lelang Waktu', 'emoji': 'alarm', 'route': Routes.lelangWaktu, 'color': const Color(0x12FFB84C), 'txtColor': const Color(0xFFFFB84C)},
      {'name': 'Titip Cerita', 'emoji': 'rocket', 'route': Routes.titipCerita, 'color': const Color(0x1239FF14), 'txtColor': const Color(0xFF39FF14)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Main Menu Warung ⚡',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildGridItem(context, menuItems[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildGridItem(context, menuItems[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGridItem(context, menuItems[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildGridItem(context, menuItems[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    final glowColor = item['txtColor'] as Color;
    return ScaleButton(
      scale: 0.95,
      onTap: () => Navigator.pushNamed(context, item['route'] as String),
      child: GlassContainer(
        borderRadius: 24,
        borderColor: glowColor.withOpacity(0.25),
        fillColor: (item['color'] as Color).withOpacity(0.08),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CyberIcon(
              item['emoji'] as String,
              size: 32,
              color: glowColor,
              glowing: true,
            ),
            const SizedBox(height: 10),
            Text(
              item['name'] as String,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBeReal(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      borderColor: const Color(0x25FFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x15FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CyberIcon('camera', size: 20, color: Color(0xFF00FFFF), glowing: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lagi Ngapain? 👀',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Ambil foto apa adanya dalam 2 menit!',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x29FF007F),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFFF007F), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CyberIcon('fire', size: 10, color: Color(0xFFFF007F)),
                    const SizedBox(width: 4),
                    Text(
                      'HOT',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFF007F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ScaleButton(
            scale: 0.95,
            onTap: () => Navigator.pushNamed(context, Routes.lagiNgapain),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF00FF), Color(0xFF8D32FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF00FF).withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: const Color(0xFF8D32FF).withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CyberIcon('camera', size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'FOTO SEKARANG 📸',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Row of other users
          Row(
            children: [
              Text(
                'Warga nongkrong lagi: ',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildMiniAvatarCircle('ERN', 'Ngopi', const Color(0x29FF007F)),
                      _buildMiniAvatarCircle('RT', 'Patroli', const Color(0x2900FFFF)),
                      _buildMiniAvatarCircle('KUC', 'Mager', const Color(0x29D500F9)),
                      _buildMiniAvatarCircle('UST', 'Kajian', const Color(0x2939FF14)),
                      _buildMiniAvatarCircle('LAP', 'Lapak', const Color(0x29FFB84C)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatarCircle(String name, String status, Color bg) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: bg,
            child: Text(
              name[0],
              style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSwapCard(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x15FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CyberIcon('handshake', size: 20, color: Color(0xFF00FFFF), glowing: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Butuh Bantuan? 🤝',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Skill Swap aktif di sekitar lo',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildSkillSwapRow(
            'Dika Pratama',
            'Figma Design',
            'Coding Python',
            const Color(0x29FF007F),
            const Color(0xFFFF007F),
          ),
          const SizedBox(height: 8),
          _buildSkillSwapRow(
            'Aulia Rahman',
            'Marketing Digital',
            'Video Editing',
            const Color(0x2939FF14),
            const Color(0xFF39FF14),
          ),
          const SizedBox(height: 18),
          ScaleButton(
            scale: 0.95,
            onTap: () => Navigator.pushNamed(context, Routes.ruangTengah),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0x15FFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x30FFFFFF)),
              ),
              child: Center(
                child: Text(
                  'Tuker Skill Sekarang 🔄',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF00FFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillSwapRow(
    String name,
    String canTeach,
    String wantsLearn,
    Color bg,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x0CFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x15FFFFFF)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: accent.withOpacity(0.2),
            child: Text(name[0], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: accent)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x2939FF14),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF39FF14), width: 0.8),
                      ),
                      child: Text(
                        'Ajarin: $canTeach',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF39FF14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, size: 10, color: Colors.white30),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x29FF007F),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFF007F), width: 0.8),
                      ),
                      child: Text(
                        'Belajar: $wantsLearn',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFF007F),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotThreads(BuildContext context) {
    final hotPosts = posts.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              const CyberIcon('fire', size: 18, color: Color(0xFFFF007F), glowing: true),
              const SizedBox(width: 8),
              Text(
                'Hot Threads Hari Ini',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: hotPosts.length,
            itemBuilder: (context, index) {
              final post = hotPosts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ScaleButton(
                  scale: 0.95,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: Material(
                            color: Colors.transparent,
                            child: _PostCard(post: post),
                          ),
                        ),
                      ),
                    );
                  },
                  child: GlassContainer(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NeonGlassPortrait(
                          character: post['character'] ?? 'Teh Erni',
                          size: 38,
                          animate: false,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                post['author'] ?? 'Warga',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                post['text'] ?? '',
                                style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const CyberIcon('chat', size: 8, color: Colors.white30),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${post['comments'] ?? 0} komen',
                                    style: GoogleFonts.nunito(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white30,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const CyberIcon('fire', size: 8, color: Color(0xFFFF007F)),
                                  const SizedBox(width: 3),
                                  Text(
                                    'HOT',
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFF007F),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeedHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CyberIcon('chat', size: 18, color: Color(0xFF00FFFF), glowing: true),
                const SizedBox(width: 8),
                Text(
                  'Meja Warung',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: ['🔥 Lagi Panas', '👀 Baru Aja Dipost'].map((t) {
                final isSelected = selectedFeedTab == t;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ScaleButton(
                    scale: 0.95,
                    onTap: () => onFeedTabChanged(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFF007F) : const Color(0x15FFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFFF007F) : const Color(0x20FFFFFF),
                        ),
                      ),
                      child: Text(
                        t.substring(2),
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              final isSelected = selectedTag == tag;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ScaleButton(
                  scale: 0.95,
                  onTap: () => onTagChanged(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00FFFF) : const Color(0x15FFFFFF),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF00FFFF) : const Color(0x20FFFFFF),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tag,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeedList(BuildContext context) {
    if (posts.isEmpty) {
      return GlassContainer(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CyberIcon('chat', size: 40, color: Colors.white30),
            const SizedBox(height: 12),
            Text(
              'Belum ada curhatan di mood/tag ini, bestie!',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Mulai obrolan seru pertama lo sekarang!',
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FadeScaleIn(
            child: _PostCard(post: posts[index]),
          ),
        );
      },
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double borderRadius;
  final Color borderColor;
  final Color fillColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.blur = 15.0,
    this.borderRadius = 24.0,
    this.borderColor = const Color(0x1BFFFFFF),
    this.fillColor = const Color(0x0EFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CyberIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color color;
  final bool glowing;

  const CyberIcon(
    this.iconName, {
    super.key,
    this.size = 24.0,
    this.color = Colors.white,
    this.glowing = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!glowing) {
      return CustomPaint(
        size: Size(size, size),
        painter: _CyberIconPainter(iconName, color),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size + 4, size + 4),
          painter: _CyberIconPainter(iconName, color.withOpacity(0.4), isGlow: true),
        ),
        CustomPaint(
          size: Size(size, size),
          painter: _CyberIconPainter(iconName, color),
        ),
      ],
    );
  }
}

class _CyberIconPainter extends CustomPainter {
  final String iconName;
  final Color color;
  final bool isGlow;

  _CyberIconPainter(this.iconName, this.color, {this.isGlow = false});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isGlow ? 4.0 : 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (isGlow) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    }

    switch (iconName) {
      case 'waving_hand':
        final path = Path()
          ..moveTo(w * 0.35, h * 0.7)
          ..lineTo(w * 0.25, h * 0.6)
          ..quadraticBezierTo(w * 0.2, h * 0.55, w * 0.25, h * 0.5)
          ..quadraticBezierTo(w * 0.3, h * 0.45, w * 0.4, h * 0.5)
          ..lineTo(w * 0.4, h * 0.3)
          ..quadraticBezierTo(w * 0.4, h * 0.2, w * 0.45, h * 0.2)
          ..quadraticBezierTo(w * 0.5, h * 0.2, w * 0.5, h * 0.3)
          ..lineTo(w * 0.5, h * 0.25)
          ..quadraticBezierTo(w * 0.5, h * 0.15, w * 0.55, h * 0.15)
          ..quadraticBezierTo(w * 0.6, h * 0.15, w * 0.6, h * 0.25)
          ..lineTo(w * 0.6, h * 0.3)
          ..quadraticBezierTo(w * 0.6, h * 0.2, w * 0.65, h * 0.2)
          ..quadraticBezierTo(w * 0.7, h * 0.2, w * 0.7, h * 0.3)
          ..lineTo(w * 0.7, h * 0.4)
          ..quadraticBezierTo(w * 0.85, h * 0.45, w * 0.8, h * 0.65)
          ..quadraticBezierTo(w * 0.75, h * 0.85, w * 0.5, h * 0.85)
          ..lineTo(w * 0.35, h * 0.7);
        canvas.drawPath(path, paint);
        break;
      case 'smile':
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.38, paint);
        canvas.drawCircle(Offset(w * 0.35, h * 0.4), 1.5, paint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(w * 0.65, h * 0.4), 1.5, paint..style = PaintingStyle.fill);
        final smilePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 0.52), radius: w * 0.2), 0.1, 2.9, false, smilePaint);
        break;
      case 'sad':
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.38, paint);
        canvas.drawCircle(Offset(w * 0.35, h * 0.4), 1.5, paint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(w * 0.65, h * 0.4), 1.5, paint..style = PaintingStyle.fill);
        final sadPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = paint.strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 0.68), radius: w * 0.15), 3.2, 3.0, false, sadPaint);
        break;
      case 'angry':
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.38, paint);
        canvas.drawLine(Offset(w * 0.28, h * 0.32), Offset(w * 0.42, h * 0.4), paint);
        canvas.drawLine(Offset(w * 0.72, h * 0.32), Offset(w * 0.58, h * 0.4), paint);
        canvas.drawCircle(Offset(w * 0.35, h * 0.45), 1.5, paint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(w * 0.65, h * 0.45), 1.5, paint..style = PaintingStyle.fill);
        canvas.drawLine(Offset(w * 0.35, h * 0.65), Offset(w * 0.65, h * 0.65), paint);
        break;
      case 'brain':
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.38, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.45, h * 0.5), radius: w * 0.15), 0, 6.28, false, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.55, h * 0.5), radius: w * 0.15), 0, 6.28, false, paint);
        break;
      case 'camera':
        final path = Path()
          ..moveTo(w * 0.15, h * 0.3)
          ..lineTo(w * 0.35, h * 0.3)
          ..lineTo(w * 0.42, h * 0.15)
          ..lineTo(w * 0.58, h * 0.15)
          ..lineTo(w * 0.65, h * 0.3)
          ..lineTo(w * 0.85, h * 0.3)
          ..quadraticBezierTo(w * 0.9, h * 0.3, w * 0.9, h * 0.35)
          ..lineTo(w * 0.9, h * 0.8)
          ..quadraticBezierTo(w * 0.9, h * 0.85, w * 0.85, h * 0.85)
          ..lineTo(w * 0.15, h * 0.85)
          ..quadraticBezierTo(w * 0.1, h * 0.85, w * 0.1, h * 0.8)
          ..lineTo(w * 0.1, h * 0.35)
          ..quadraticBezierTo(w * 0.1, h * 0.3, w * 0.15, h * 0.3)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawCircle(Offset(w * 0.5, h * 0.57), w * 0.18, paint);
        break;
      case 'casino':
        canvas.drawRect(Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.6, height: h * 0.6), paint);
        canvas.drawCircle(Offset(w * 0.35, h * 0.35), 2.0, paint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(w * 0.65, h * 0.65), 2.0, paint..style = PaintingStyle.fill);
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), 3.0, paint..style = PaintingStyle.fill);
        break;
      case 'campaign':
        final path = Path()
          ..moveTo(w * 0.15, h * 0.45)
          ..lineTo(w * 0.4, h * 0.45)
          ..lineTo(w * 0.7, h * 0.2)
          ..lineTo(w * 0.7, h * 0.8)
          ..lineTo(w * 0.4, h * 0.55)
          ..lineTo(w * 0.15, h * 0.55)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.72, h * 0.5), radius: w * 0.12), -1.0, 2.0, false, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.72, h * 0.5), radius: w * 0.24), -1.0, 2.0, false, paint);
        break;
      case 'alarm':
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.3, paint);
        canvas.drawLine(Offset(w * 0.5, h * 0.5), Offset(w * 0.5, h * 0.3), paint);
        canvas.drawLine(Offset(w * 0.5, h * 0.5), Offset(w * 0.65, h * 0.5), paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.25, h * 0.25), radius: w * 0.08), 3.14, 1.57, false, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.75, h * 0.25), radius: w * 0.08), -1.57, 1.57, false, paint);
        break;
      case 'rocket':
        final path = Path()
          ..moveTo(w * 0.5, h * 0.15)
          ..quadraticBezierTo(w * 0.75, h * 0.38, w * 0.75, h * 0.65)
          ..lineTo(w * 0.6, h * 0.65)
          ..lineTo(w * 0.5, h * 0.85)
          ..lineTo(w * 0.4, h * 0.65)
          ..lineTo(w * 0.25, h * 0.65)
          ..quadraticBezierTo(w * 0.25, h * 0.38, w * 0.5, h * 0.15)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'handshake':
        canvas.drawCircle(Offset(w * 0.38, h * 0.5), w * 0.18, paint);
        canvas.drawCircle(Offset(w * 0.62, h * 0.5), w * 0.18, paint);
        break;
      case 'fire':
        final path = Path()
          ..moveTo(w * 0.5, h * 0.15)
          ..quadraticBezierTo(w * 0.75, h * 0.45, w * 0.75, h * 0.75)
          ..quadraticBezierTo(w * 0.75, h * 0.9, w * 0.5, h * 0.9)
          ..quadraticBezierTo(w * 0.25, h * 0.9, w * 0.25, h * 0.75)
          ..quadraticBezierTo(w * 0.25, h * 0.45, w * 0.5, h * 0.15)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'chat':
        final path = Path()
          ..moveTo(w * 0.15, h * 0.25)
          ..lineTo(w * 0.85, h * 0.25)
          ..quadraticBezierTo(w * 0.9, h * 0.25, w * 0.9, h * 0.3)
          ..lineTo(w * 0.9, h * 0.65)
          ..quadraticBezierTo(w * 0.9, h * 0.7, w * 0.85, h * 0.7)
          ..lineTo(w * 0.45, h * 0.7)
          ..lineTo(w * 0.25, h * 0.85)
          ..lineTo(w * 0.25, h * 0.7)
          ..lineTo(w * 0.15, h * 0.7)
          ..quadraticBezierTo(w * 0.1, h * 0.7, w * 0.1, h * 0.65)
          ..lineTo(w * 0.1, h * 0.3)
          ..quadraticBezierTo(w * 0.1, h * 0.25, w * 0.15, h * 0.25)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'notification':
        final path = Path()
          ..moveTo(w * 0.5, h * 0.15)
          ..quadraticBezierTo(w * 0.7, h * 0.3, w * 0.7, h * 0.6)
          ..lineTo(w * 0.8, h * 0.7)
          ..lineTo(w * 0.2, h * 0.7)
          ..lineTo(w * 0.3, h * 0.6)
          ..quadraticBezierTo(w * 0.3, h * 0.3, w * 0.5, h * 0.15)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 0.75), radius: w * 0.08), 0.0, 3.14, false, paint);
        break;
      case 'qr':
        canvas.drawRect(Rect.fromLTRB(w * 0.2, h * 0.2, w * 0.42, h * 0.42), paint);
        canvas.drawRect(Rect.fromLTRB(w * 0.58, h * 0.2, w * 0.8, h * 0.42), paint);
        canvas.drawRect(Rect.fromLTRB(w * 0.2, h * 0.58, w * 0.42, h * 0.8), paint);
        canvas.drawRect(Rect.fromLTRB(w * 0.58, h * 0.58, w * 0.8, h * 0.8), paint);
        break;
      default:
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _StoryItem extends StatelessWidget {
  final Map<String, String> story;
  const _StoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [WC.primary, WC.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: WC.bg,
                    shape: BoxShape.circle,
                  ),
                  child: NeonGlassPortrait(
                    character: story['character']!,
                    size: 46,
                    animate: false,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: WC.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: WC.bg, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            story['name']!,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: WC.textMid,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late Map<String, int> _reactions;
  bool _hasVoted = false;
  String? _votedChoice;
  late int _votesA;
  late int _votesB;
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _reactions = Map<String, int>.from(widget.post['reactions'] as Map<String, int>);
    _votesA = widget.post['votesA'] ?? 0;
    _votesB = widget.post['votesB'] ?? 0;
    
    // Load dynamic comments from post database
    _comments = widget.post['commentList'] != null
        ? List<Map<String, dynamic>>.from(widget.post['commentList'] as List)
        : <Map<String, dynamic>>[];
  }

  // === SAFETY FILTER (mirrored in _PostCardState for local access) ===
  static const List<String> _bannedWords = [
    'bangsat', 'brengsek', 'bajingan', 'keparat', 'goblok', 'tolol',
    'bego', 'idiot', 'bodoh', 'kampret', 'kontol', 'memek', 'ngentot',
    'jancok', 'asu', 'anjing', 'bangke', 'bitch', 'fuck', 'shit',
    'asshole', 'cunt', 'bastard', 'damn', 'hell',
  ];

  bool _containsBannedWords(String text) {
    final lower = text.toLowerCase();
    return _bannedWords.any((word) => lower.contains(word));
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WC.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: const [
            Text('👮‍♂️🚨', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Laporan Masuk!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Hansip & Pak RT meluncur untuk investigasi ronda! 🚨\n\n'
          'Tenang bestie, postingan ini akan ditinjau dalam patroli malam nanti agar warkop kita tetep aman, tentram, dan bebas drama toxic. 🫡☕',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: WC.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Siap Ndan! 🫡',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: WC.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WC.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: const [
            Text('🗑️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text('Hapus Post?', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Superadmin mode aktif! Post ini akan dihapus permanen dari Meja Warung. Yakin, Ndan? 🫡',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: WC.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batalkan', style: GoogleFonts.poppins(color: WC.textMid, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final postId = widget.post['id'] ?? widget.post['text'];
              try {
                await FirebaseService().deletePost(postId as String);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: WC.danger,
                      content: const Text('🗑️ Post berhasil dihapus oleh Superadmin!'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal hapus: $e')),
                  );
                }
              }
            },
            child: Text('Hapus! 🗑️', style: GoogleFonts.poppins(color: WC.danger, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _incrementReaction(String key) {
    setState(() {
      _reactions[key] = (_reactions[key] ?? 0) + 1;
    });
  }

  void _showCommentsModal() {
    final TextEditingController commentCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  'Obrolan Warga 🗣️',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: WC.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                
                // List of comments
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _comments.length,
                    itemBuilder: (context, idx) {
                      final c = _comments[idx];
                      final bool isBot = c['author'].toString().contains('Teh Erni');
                      return GestureDetector(
                        onTap: () {
                          // Quick nested reply tag insertion
                          commentCtrl.text = '@${c['author'].toString().replaceAll(' 💅', '')} ' + commentCtrl.text;
                          commentCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: commentCtrl.text.length),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isBot ? WC.primaryLight : WC.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isBot ? WC.primary.withOpacity(0.3) : WC.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    c['author'] as String,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      color: isBot ? WC.primary : WC.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (c['isAbsen1'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                      ),
                                      child: Text(
                                        '🥇 Absen 1',
                                        style: GoogleFonts.poppins(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  const Spacer(),
                                  Text(
                                    c['time'] as String,
                                    style: GoogleFonts.nunito(
                                      fontSize: 9,
                                      color: WC.textLight,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c['text'] as String,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isBot ? Colors.white : WC.textMid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // === GEN Z EMOJI QUICK BAR ===
                SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['🔥', '😂', '💯', '👀', '🍵', '😭', '👍', '🙏', '❤️', '😱'].map((emoji) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () {
                            commentCtrl.text = commentCtrl.text + emoji;
                            commentCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: commentCtrl.text.length),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: WC.surface,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: WC.border),
                            ),
                            child: Center(
                              child: Text(emoji, style: const TextStyle(fontSize: 11)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Add comment input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Ikut nimbrung, Tulis pendapat lo... ☕',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ScaleButton(
                      onTap: () {
                        final commentText = commentCtrl.text.trim();
                        if (commentText.isEmpty) return;

                        // === SAFETY FILTER: Cek kata sensitif sebelum komentar ===
                        if (_containsBannedWords(commentText)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: WC.danger,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              content: Row(
                                children: const [
                                  Text('👮‍♂️', style: TextStyle(fontSize: 18)),
                                  SizedBox(width: 8),
                                  Expanded(child: Text('Hansip: Lah, komennya toxic woy! Patroli aktif, jangan coba-coba! 🚨')),
                                ],
                              ),
                            ),
                          );
                          return;
                        }
                        
                        setModalState(() {
                          final isFirst = _comments.isEmpty;
                          _comments.add({
                            'author': (WS.isLoggedIn && WS.userName.isNotEmpty) ? WS.userName : 'Sobat Warung',
                            'text': commentText,
                            'time': 'Baru saja',
                            'isAbsen1': isFirst,
                          });
                          widget.post['comments'] = (widget.post['comments'] ?? 0) + 1;
                          widget.post['commentList'] = _comments;
                          
                          if (isFirst) {
                            WS.kopiBalance += 1.0; // Absen 1 gets +1 Kopi riil!
                          }
                        });
                        setState(() {});
                        commentCtrl.clear();

                        if (_comments.length == 1) {
                          // First comment gets +1 Kopi bonus!
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: WC.success,
                              content: Text('🎉 Absen 1 Pertama! Bonus +1 Kopi dikirim ke dompet lo ☕⚡'),
                            ),
                          );
                        }

                        // === TEH ERNI AUTO COMMENT ENGAGEMENT TRIGGER ===
                        // 25% chance of triggering sassy reply after 1.5 seconds
                        if (DateTime.now().millisecond % 4 == 0) {
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            if (mounted) {
                              final List<String> erniReplies = [
                                "Sendirian lagi ngab? 😏",
                                "Itu keliatan enak banget sih, mau dong dibagikan di Dapur 🍵",
                                "Drama sirkel apalagi ini ya ampun... 👀",
                                "Kasbon dulu gak sih ngab biar anget? 😂",
                                "Mending lu traktir kopi gue aja dah wkwk ☕",
                                "Sassy bener komennya, wkwk relate tapi! 💅",
                              ];
                              final randomReply = erniReplies[DateTime.now().millisecond % erniReplies.length];
                              setModalState(() {
                                _comments.add({
                                  'author': 'Teh Erni AI 💅',
                                  'text': randomReply,
                                  'time': 'Baru saja',
                                  'isAbsen1': false,
                                });
                                widget.post['comments'] = (widget.post['comments'] ?? 0) + 1;
                                widget.post['commentList'] = _comments;
                              });
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: WC.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVsVotingWidget(Map<String, dynamic> post) {
    final total = _votesA + _votesB;
    final percentA = total > 0 ? (_votesA / total * 100).toStringAsFixed(0) : '0';
    final percentB = total > 0 ? (_votesB / total * 100).toStringAsFixed(0) : '0';

    return Column(
      children: [
        if (!_hasVoted) ...[
          Row(
            children: [
              Expanded(
                child: ScaleButton(
                  onTap: () {
                    setState(() {
                      _votesA += 1;
                      _hasVoted = true;
                      _votedChoice = 'A';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEF), // soft red
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: WC.primary.withOpacity(0.3), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        post['choiceA'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: WC.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ScaleButton(
                  onTap: () {
                    setState(() {
                      _votesB += 1;
                      _hasVoted = true;
                      _votedChoice = 'B';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FF), // soft blue
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: WC.secondary.withOpacity(0.3), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        post['choiceB'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: WC.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WC.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${post['choiceA']} ($percentA%)',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: _votedChoice == 'A' ? FontWeight.w900 : FontWeight.w700,
                        color: _votedChoice == 'A' ? WC.primary : const Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      '${post['choiceB']} ($percentB%)',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: _votedChoice == 'B' ? FontWeight.w900 : FontWeight.w700,
                        color: _votedChoice == 'B' ? WC.secondary : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: _votesA,
                          child: Container(color: WC.primary),
                        ),
                        Expanded(
                          flex: _votesB,
                          child: Container(color: WC.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Suara sah didata Pak RT! 🗳️',
                    style: GoogleFonts.nunito(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: WC.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final int likes = (post['likes'] as num?)?.toInt() ?? 0;
    final int commentsCount = (post['commentsCount'] as num?)?.toInt()
        ?? (post['comments'] is int ? post['comments'] as int : _comments.length);
    final bool isHot = likes > 10 || commentsCount > 5;
    final bool isSuperAdmin = WS.userRole == 'superadmin';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: post['bg'] as Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHot ? WC.primary.withOpacity(0.8) : WC.border,
          width: isHot ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isHot ? WC.primary.withOpacity(0.12) : Colors.black.withOpacity(0.02),
            blurRadius: isHot ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                NeonGlassPortrait(
                  character: post['character'] as String,
                  size: 28,
                  animate: false,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['author'] as String,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (post['moodLabel'] != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: WC.primaryLight,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                post['moodLabel'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: WC.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (isHot)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [WC.primary, WC.accent],
                                ),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: WC.primary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('☕', style: TextStyle(fontSize: 8)),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Spill The Tea! ✨',
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            post['time'] as String,
                            style: GoogleFonts.nunito(
                              fontSize: 9,
                              color: const Color(0xFF666680),
                            ),
                          ),
                          if (post['location'] != null) ...[
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(fontSize: 9, color: Color(0xFF666680))),
                            const SizedBox(width: 4),
                            Text(
                              post['location'] as String,
                              style: GoogleFonts.nunito(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: WC.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      post['emoji'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.report_gmailerrorred_rounded, size: 16, color: WC.danger),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _showReportDialog(context),
                    ),
                    if (isSuperAdmin) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Hapus Post (Superadmin)',
                        onPressed: () => _showDeleteConfirmation(context),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Content
            Text(
              post['text'] as String,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                height: 1.4,
              ),
            ),

            // === PHOTO RENDER SECTION ===
            if (post['imageUrl'] != null || post['imageData'] != null) ...[
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: post['imageUrl'] != null
                        ? Image.network(
                            post['imageUrl'] as String,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.white.withOpacity(0.1),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: WC.primary),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: WC.surface,
                              child: const Center(
                                child: Icon(Icons.broken_image_rounded, color: WC.textLight, size: 32),
                              ),
                            ),
                          )
                        : Image.memory(
                            post['imageData'] as Uint8List,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ],

            if (post['isVsMode'] == true) ...[
              const SizedBox(height: 8),
              _buildVsVotingWidget(post),
            ],

            const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: (post['tags'] as List<String>)
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: WC.primary,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            if (post['isContinued'] == true) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: WC.primaryLight,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: WC.primary.withOpacity(0.2)),
                    ),
                    child: Text(
                      '📖 Bersambung...',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: WC.primary,
                      ),
                    ),
                  ),
                  ScaleButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: WC.success,
                          content: Row(
                            children: const [
                              Text('🔔', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Text('Bakal dikabarin pas Part 2 rilis! 😉'),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: WC.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Minta Part 2 🔔',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),
            Divider(height: 1, color: WC.border.withOpacity(0.5)),
            const SizedBox(height: 8),

            // Hook System (Addiction Loop) — real-time count from _comments
            if (_comments.length > 10) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: WC.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('💬', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Ada ${_comments.length} warga lagi nimbrung...',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: WC.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_comments.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBE6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Warga lagi rame nimbrung! Seru banget...',
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: WC.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Emotional Reactions Row
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _reactions.entries.map((e) {
                        String label = e.key;
                        if (e.key == '🤗') label = '🤗 Peluk';
                        if (e.key == '💪') label = '💪 Semangat';
                        if (e.key == '🔥') label = '🔥 Relate';
                        if (e.key == '🧠') label = '🧠 Dalem';
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ScaleButton(
                            onTap: () => _incrementReaction(e.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: WC.border),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    label,
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${e.value}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ScaleButton(
                  onTap: _showCommentsModal,
                  child: Row(
                    children: [
                      const Icon(Icons.forum_rounded, size: 12, color: WC.primary),
                      const SizedBox(width: 3),
                      Text(
                        '${_comments.length} Nimbrung',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: WC.primary,
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
}

class RealTimeActivityBanner extends StatefulWidget {
  const RealTimeActivityBanner({super.key});

  @override
  State<RealTimeActivityBanner> createState() => _RealTimeActivityBannerState();
}

class _RealTimeActivityBannerState extends State<RealTimeActivityBanner> {
  int _curhatCount = 120;
  int _skillCount = 45;
  int _bannerIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _bannerIndex = (_bannerIndex + 1) % 5;
          _curhatCount = 110 + (DateTime.now().millisecond % 40);
          _skillCount = 35 + (DateTime.now().millisecond % 25);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    String emoji = '🔥';
    switch (_bannerIndex) {
      case 0:
        text = '$_curhatCount warga lagi curhat di Meja Warung';
        emoji = '🔥';
        break;
      case 1:
        text = '$_skillCount warga lagi barter skill di Ruang Tengah';
        emoji = '⚡';
        break;
      case 2:
        text = 'Ada 12 warga lagi nimbrung aktif saat ini...';
        emoji = '🗣️';
        break;
      case 3:
        text = '3 warga lagi ngetik curhat panas...';
        emoji = '💬';
        break;
      case 4:
        text = 'Warung lagi sepi nih... Ada cerita gokil baru?';
        emoji = '🧐';
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: WC.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.primary.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: WC.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Text(
              emoji,
              key: ValueKey(emoji),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Text(
                text,
                key: ValueKey(text),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: WC.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
