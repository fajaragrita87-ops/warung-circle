import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/fade_scale_in.dart';
import 'package:warung_circle/widgets/kopi_button.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';
import 'package:warung_circle/widgets/warung_shell.dart';
import 'package:warung_circle/screens/home_screen.dart';
import 'dart:async';

class TitipCeritaScreen extends StatefulWidget {
  const TitipCeritaScreen({super.key});

  @override
  State<TitipCeritaScreen> createState() => _TitipCeritaScreenState();
}

class _TitipCeritaScreenState extends State<TitipCeritaScreen> {
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;
  bool _isShared = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'text': 'Haii bestie! 🍵 Gue Teh Erni, teman curhat lo yang paling sassy se-Warung Circle! Cerita apa nih yang mau dititipin? Gue siap dengerin, walaupun drama lo lebih panjang dari sinetron 😂',
      'time': 'Sekarang',
    }
  ];
  final List<String> _suggestions = [
    'Lagi galau sama mantan 💔',
    'Kerjaan bikin stress 😤',
    'Teman PHP lagi 😭',
    'Mau curhat hal positif ✨',
  ];

  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _resetIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() {
        final idleQuotes = [
          'Gua liat lu dari tadi diem aja... Lagi ngelamunin utang atau nungguin chat si dia? 😏',
          'Kok sepi sih bestie? 🧐 Cerita dong, gua siap dengerin nih biar kancut ga jamuran 😂',
          'Ada cerita panas baru gak hari ini? Jangan dipendem sendiri dong, pamali! 💅',
          'Lagi mikirin apa sih serius amat? Sini curhat ke Teh Erni biar enteng pikiran lo 🍵',
        ];
        final randomQuote = idleQuotes[DateTime.now().millisecond % idleQuotes.length];
        _messages.add({
          'isBot': true,
          'text': randomQuote,
          'time': 'Baru saja',
        });
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WarungShell(
      title: '✨ Titip Cerita',
      currentIndex: 2,
      showFab: false,
      body: Column(
        children: [
          // Bot header card
          FadeScaleIn(
            child: _buildBotHeader(),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_isTyping && i == _messages.length) {
                  return _TypingIndicator();
                }
                return _MessageBubble(msg: _messages[i]);
              },
            ),
          ),

          // Suggestions chips
          if (_messages.length == 1 && !_isTyping)
            _buildSuggestions(),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildBotHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WC.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WC.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const NeonGlassPortrait(character: 'Teh Erni', size: 46, animate: false),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Teh Erni AI', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 14, color: WC.textDark)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: WC.success, borderRadius: BorderRadius.circular(100)),
                      child: Text('Online', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
                Text('AI Sassy • Curhat & Saran Hidup 🍵', style: GoogleFonts.nunito(fontSize: 11, color: WC.textMid)),
              ],
            ),
          ),
          ScaleButton(
            onTap: _isShared 
              ? null
              : () {
                  final userMessages = _messages.where((m) => !(m['isBot'] as bool)).toList();
                  if (userMessages.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ketik curhatan lo dulu dong bestie sebelum dishare! 😂')),
                    );
                    return;
                  }
                  final lastText = userMessages.last['text'] as String;
                  
                  // Insert anonymously into public feed!
                  HomeScreen.globalPosts.insert(0, {
                    'author': 'Anon Warung 👻',
                    'character': 'Kucing',
                    'time': 'Baru saja',
                    'bg': const Color(0xFFFFECEF), // soft coral
                    'emoji': '🍵',
                    'mood': '😔 Sedih',
                    'moodLabel': 'Lagi Curhat',
                    'text': lastText,
                    'reactions': {'🤗': 2, '💪': 1, '🧠': 0, '🔥': 4},
                    'comments': 1,
                    'tags': ['#CurhatBaper'],
                  });

                  setState(() {
                    _isShared = true;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: WC.success,
                      content: const Text('🎉 Cerita lo berhasil nangkring secara anonim di Meja Warung! Warga siap nimbrung!'),
                    ),
                  );
                },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isShared ? WC.textLight : WC.primary, 
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                _isShared ? 'Shared ✓' : 'Share 📤', 
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _suggestions.map((s) => ScaleButton(
          onTap: () { _inputCtrl.text = s; _sendMessage(); },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: WC.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: WC.border)),
            child: Text(s, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: WC.textMid)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildInputBar() {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, isKeyboardOpen ? 16 : 96),
      decoration: BoxDecoration(
        color: WC.surface,
        border: Border(top: BorderSide(color: WC.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Cerita apaan nih bestie? 🤗',
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          ScaleButton(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: WC.primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: WC.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _idleTimer?.cancel();
    setState(() {
      _messages.add({'isBot': false, 'text': text, 'time': 'Baru saja'});
      _isTyping = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    String responseText;
    try {
      responseText = await _fetchTehErniAIResponse(text);
    } catch (e) {
      responseText = _generateResponse(text);
    }

    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add({
        'isBot': true,
        'text': responseText,
        'time': 'Baru saja',
      });
    });
    _scrollToBottom();
    _resetIdleTimer();
  }

  Future<String> _fetchTehErniAIResponse(String userMessage) async {
    // API token dikosongkan — response menggunakan fallback lokal yang sudah keren
    const String hfToken = "";
    final String prompt = """<s>[INST] Kamu adalah Teh Erni, admin Warung Circle yang paling gosip, galak tapi sayang, suka ngasih saran receh, dan berbicara dengan bahasa gaul anak Jaksel/Depok.
User berkata: "$userMessage"
Balas curhatan ini dengan gaya gaul, singkat, sedikit pedas tapi menyayangi! [/INST]""";

    try {
      final response = await http.post(
        Uri.parse("https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.2"),
        headers: {
          "Authorization": "Bearer $hfToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "inputs": prompt,
          "parameters": {
            "max_new_tokens": 120,
            "temperature": 0.7,
          }
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['generated_text'] != null) {
          String reply = data[0]['generated_text'] as String;
          if (reply.contains('[/INST]')) {
            reply = reply.substring(reply.indexOf('[/INST]') + 7).trim();
          }
          if (reply.isNotEmpty) {
            return reply;
          }
        }
      }
    } catch (e) {
      // Fallback silently to mock generator
    }
    
    return _generateResponse(userMessage);
  }

  String _generateResponse(String input) {
    final lower = input.toLowerCase();

    // 1. Warning Mode (Toxic Behavior Detection)
    final toxicWords = [
      'anjing', 'babi', 'goblok', 'tolol', 'bangsat', 'kontol', 'fuck', 'shit', 'bajingan', 'pantek'
    ];
    for (var word in toxicWords) {
      if (lower.contains(word)) {
        return 'Heh! Kurang kopi lu ya? Di warung gue bebas nimbrung & curhat tapi cangkirnya dijaga, jangan kasar ya bestie! Jaim dikit napa 💅';
      }
    }

    // 2. Emotional Mode (Curhat / Galau Detection)
    if (lower.contains('mantan') || lower.contains('galau') || lower.contains('sakit hati') || lower.contains('putus') || lower.contains('nangis')) {
      return 'Yah bestie... 😭 Mantan emang kayak wifi gratisan — sering putus-putus, tapi pas lo udah langganan wifi premium baru tau bedanya! Ingat, lo terlalu kece buat orang yang gak bisa hargain lo. Tarik nafas pelan, block nomornya, dan next! 💅✨';
    } 
    
    // 3. Emotional Mode (Stress / Capek / Pekerjaan Detection)
    else if (lower.contains('kerja') || lower.contains('stress') || lower.contains('capek') || lower.contains('lelah') || lower.contains('kuliah') || lower.contains('tugas') || lower.contains('bos')) {
      return 'Cuy cuy, napas dulu dong! 😤 Lo bukan mesin genset warkop yang harus nyala terus. Istirahat gih! Bahkan Teh Erni aja butuh break nyeduh kopi. Inget, kesehatan mental lo nomor satu! Teh Erni siap temenin curhat lagi pas lo udah segeran ☕';
    } 
    
    // 4. Normal Mode (Kabar Gembira / Positive Mode)
    else if (lower.contains('senang') || lower.contains('bahagia') || lower.contains('lulus') || lower.contains('menang') || lower.contains('pacar baru') || lower.contains('berhasil')) {
      return 'AYY BESTIE SEMANGATTTTT! 🎉🔥 Seneng banget gue denger kabar gembira lo! Meja Warung wajib tau nih biar semuanya ikutan happy. Post curhat lo secara publik gih! Semoga nular ya positif energinya ke warga lain! ❤️';
    } 
    
    // 5. Default Sassy / Caring Normal Mode Responses
    else {
      final defaultReplies = [
        'Waduh, ini situasinya emang rada rumit ya bestie 🤔 Tapi gue percaya lo punya kekuatan buat handle ini! Tips Teh Erni: minum kopi anget, napas pelan, dan anggep ini bumbu hidup warkop. Lo gak sendirian! 💪',
        'Ahaha gokil sih ini! 😂 Tapi serius, menurut gue lo ambil jalan tengah aja. Jangan terlalu dipikirin biar gak cepet ubanan. Mau teh anget or curhat lagi?',
        'Hmmm menarik... Gue dengerin kok bestie, lanjutin ceritanya! Bagian mananya nih yang bikin paling gregetan? 😏',
        'Inget ya bestie, badai pasti berlalu. Kalau belum berlalu, sini melipir ke dapur Teh Erni, kita seduh kopi bareng biar tenang ☕✨',
      ];
      return defaultReplies[DateTime.now().millisecond % defaultReplies.length];
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> msg;
  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isBot = msg['isBot'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) ...[
            const NeonGlassPortrait(character: 'Teh Erni', size: 32, animate: false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isBot ? WC.surface : WC.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isBot ? 4 : 20),
                  bottomRight: Radius.circular(isBot ? 20 : 4),
                ),
                border: isBot ? Border.all(color: WC.border) : null,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Text(
                msg['text'] as String,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isBot ? WC.textDark : Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const NeonGlassPortrait(character: 'Teh Erni', size: 32, animate: false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: WC.surface,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20), bottomLeft: Radius.circular(4)),
              border: Border.all(color: WC.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Container(
                  margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: WC.primary.withOpacity(0.3 + (_ctrl.value * 0.7 * (i == 1 ? 0.8 : 1.0))),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
