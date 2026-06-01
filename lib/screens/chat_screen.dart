import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:warung_circle/theme/warung_colors.dart';
import 'package:warung_circle/widgets/neon_glass_portrait.dart';
import 'package:warung_circle/widgets/scale_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  String _activeChat = 'Teh Erni';
  bool _isTyping = false;

  final Map<String, List<Map<String, dynamic>>> _chatHistory = {
    'Teh Erni': [
      {'isMe': false, 'text': 'Haii! Ada yang bisa Teh Erni bantu hari ini? ☕', 'time': '10:00'},
      {'isMe': true, 'text': 'Pengen curhat dong Teh!', 'time': '10:01'},
      {'isMe': false, 'text': 'Yuk yuk! Cerita dulu, Teh Erni dengerin sambil minum teh 🍵😄', 'time': '10:01'},
    ],
    'Pak RT': [
      {'isMe': false, 'text': '⚠️ Informasi dari Pak RT: Jangan lupa bayar iuran warung bulan ini ya warga!', 'time': 'Kemarin'},
      {'isMe': true, 'text': 'Siap Pak RT!', 'time': 'Kemarin'},
    ],
    'Kucing Warung': [
      {'isMe': false, 'text': 'Meooong 🐱 (ini Kucing Warung, gue cuma mau bilang lo keren hari ini)', 'time': '2 hari lalu'},
    ],
  };

  final _chatList = [
    {'name': 'Teh Erni', 'character': 'Teh Erni', 'preview': 'Yuk curhat dulu bestie! ☕', 'time': '10:01', 'unread': 1},
    {'name': 'Pak RT', 'character': 'Pak RT', 'preview': 'Jangan lupa iuran ya!', 'time': 'Kemarin', 'unread': 0},
    {'name': 'Kucing Warung', 'character': 'Kucing', 'preview': 'Meooong 🐱', 'time': '2 hari lalu', 'unread': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WC.bg,
      appBar: AppBar(
        backgroundColor: WC.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: WC.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chat Warung 💬', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, color: WC.textDark)),
      ),
      body: Row(
        children: [
          // Chat list sidebar (on wider screens)
          if (MediaQuery.of(context).size.width > 600)
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: WC.surface,
                border: Border(right: BorderSide(color: WC.border)),
              ),
              child: _buildChatList(),
            ),

          // Active chat
          Expanded(child: _buildActiveChat()),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Pesan', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, color: WC.textDark)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _chatList.length,
            itemBuilder: (ctx, i) {
              final chat = _chatList[i];
              final isActive = chat['name'] == _activeChat;
              return ScaleButton(
                onTap: () => setState(() => _activeChat = chat['name'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: isActive ? WC.primaryLight : Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      NeonGlassPortrait(character: chat['character'] as String, size: 44, animate: false),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chat['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: WC.textDark)),
                            Text(chat['preview'] as String, style: GoogleFonts.nunito(fontSize: 11, color: WC.textLight), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(chat['time'] as String, style: GoogleFonts.nunito(fontSize: 10, color: WC.textLight)),
                          if ((chat['unread'] as int) > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: 18, height: 18,
                              decoration: const BoxDecoration(color: WC.primary, shape: BoxShape.circle),
                              child: Center(child: Text('${chat['unread']}', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveChat() {
    final messages = _chatHistory[_activeChat] ?? [];
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: WC.surface,
            border: Border(bottom: BorderSide(color: WC.border)),
          ),
          child: Row(
            children: [
              NeonGlassPortrait(character: _activeChat == 'Kucing Warung' ? 'Kucing' : _activeChat, size: 40, animate: false),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_activeChat, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: WC.textDark)),
                    Row(children: [
                      Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 4), decoration: const BoxDecoration(color: WC.success, shape: BoxShape.circle)),
                      Text('Online', style: GoogleFonts.nunito(fontSize: 10, color: WC.success)),
                    ]),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_vert_rounded, color: WC.textLight), onPressed: () {}),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (ctx, i) {
              if (_isTyping && i == messages.length) {
                return _buildTypingIndicator();
              }
              final msg = messages[i];
              final isMe = msg['isMe'] as bool;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe) ...[
                      NeonGlassPortrait(
                        character: _activeChat == 'Kucing Warung' ? 'Kucing' : _activeChat,
                        size: 30, animate: false,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe ? WC.primary : WC.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isMe ? 18 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 18),
                              ),
                              border: isMe ? null : Border.all(color: WC.border),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Text(
                              msg['text'] as String,
                              style: GoogleFonts.nunito(
                                fontSize: 13, fontWeight: FontWeight.w600,
                                color: isMe ? Colors.white : WC.textDark,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(msg['time'] as String, style: GoogleFonts.nunito(fontSize: 9, color: WC.textLight)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          decoration: BoxDecoration(color: WC.surface, border: Border(top: BorderSide(color: WC.border))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(hintText: 'Ketik pesan...'),
                  onSubmitted: (_) => _sendMsg(),
                ),
              ),
              const SizedBox(width: 10),
              ScaleButton(
                onTap: _sendMsg,
                child: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: WC.primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: WC.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendMsg() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _isTyping) return;
    setState(() {
      _chatHistory[_activeChat]!.add({'isMe': true, 'text': text, 'time': 'Baru saja'});
      _isTyping = true;
    });
    _ctrl.clear();
    _scrollToBottom();

    // Delay 1.5s to feel like human typing
    await Future.delayed(const Duration(milliseconds: 1500));

    String reply;
    try {
      reply = await _fetchCharacterResponse(text, _activeChat);
    } catch (e) {
      reply = _generateLocalFallback(text, _activeChat);
    }

    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _chatHistory[_activeChat]!.add({'isMe': false, 'text': reply, 'time': 'Baru saja'});
    });
    _scrollToBottom();
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

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NeonGlassPortrait(
            character: _activeChat == 'Kucing Warung' ? 'Kucing' : _activeChat,
            size: 30,
            animate: false,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: WC.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: WC.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) => _TypingDot(index: index)),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _fetchCharacterResponse(String text, String character) async {
    if (character == 'Teh Erni') {
      // API token dikosongkan — response menggunakan fallback lokal yang sudah keren
      const String hfToken = "";
      final String prompt = """<s>[INST] Kamu adalah Teh Erni, admin Warung Circle yang paling gosip, galak tapi sayang, suka ngasih saran receh, dan berbicara dengan bahasa gaul anak Jaksel/Depok.
User berkata: "$text"
Balas obrolan ini dengan gaya gaul, singkat, sedikit pedas tapi menyayangi! [/INST]""";

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
        // Fallback silently
      }
    }

    return _generateLocalFallback(text, character);
  }

  String _generateLocalFallback(String input, String character) {
    final lower = input.toLowerCase();

    if (character == 'Teh Erni') {
      // 1. Toxic Behavior
      final toxicWords = ['anjing', 'babi', 'goblok', 'tolol', 'bangsat', 'kontol', 'fuck', 'shit'];
      for (var word in toxicWords) {
        if (lower.contains(word)) {
          return 'Heh! Mulutnya dijaga ya bestie! Gue emang gaul tapi dilarang toxic di warkop gue. Sini gue siram es teh manis biar adem tuh lambung 💅';
        }
      }

      // 2. Love / Relationship
      if (lower.contains('mantan') || lower.contains('galau') || lower.contains('cinta') || lower.contains('putus') || lower.contains('pacar')) {
        return 'Duh, pagi-pagi udah ngomongin mantan 🙄 Mantan tuh kayak tisu basah bekas pakai, udah lecek jangan dipungut lagi! Mending traktir gue gorengan di dapur warkop, biar hari lo lebih cerah ✨';
      }

      // 3. Work / Stress
      if (lower.contains('kerja') || lower.contains('stress') || lower.contains('capek') || lower.contains('tugas') || lower.contains('kuliah')) {
        return 'Napas dulu Ngab! 😤 Kerjaan ga bakal beres kalau lo stress. Mending selonjoran dulu, pesen kopi susu di lapak, terus dengerin gosip warkop biar otak lo ga ngebul!';
      }

      // Default
      final defaultReplies = [
        'Woy bestie, seru juga cerita lo! 😂 Tapi daripada gabut, ikutan Lelang Waktu yuk? Lumayan dapet koin Kopi gratis ☕',
        'Hmm, menurut gue sih mending lo bawa santai aja. Hidup cuma sekali, jangan dibikin ribet kayak antrean sembako gratis wkwk 💅',
        'Eh beneran? Kok gue baru tau gosip ini! Wah, kudu lapor Pak RT nih biar diusut tuntas 😂',
        'Inget ya bestie, badai pasti berlalu. Kalau belum berlalu, ya berarti lo butuh payung or es kelapa muda warkop 🥥✨',
      ];
      return defaultReplies[DateTime.now().millisecond % defaultReplies.length];
    } 
    
    else if (character == 'Pak RT') {
      if (lower.contains('iuran') || lower.contains('bayar') || lower.contains('uang') || lower.contains('duit')) {
        return 'Nah bener! Jangan pura-pura lupa ya, uang kas RT bulan ini 20 Kopi belum lunas. Nanti saya coret dari daftar pembagian bansos gorengan baru tau rasa! 👮‍♂️';
      }
      if (lower.contains('ronda') || lower.contains('aman') || lower.contains('patroli') || lower.contains('maling') || lower.contains('jaga')) {
        return 'Malam ini giliran pos ronda aktif ya! Kamu dapet jatah jam 2 pagi bareng Hansip. Kopi sama biskuit regal udah disiapin di pos kamling, jangan molor! 👮‍♂️🚨';
      }
      if (lower.contains('bubur') || lower.contains('aduk')) {
        return 'Sekte bubur diaduk atau pisah itu semua ciptaan manusia. Yang penting rukun tetangga tetap terjaga! Tapi kalau tanya pribadi saya, bubur diaduk itu kriminalitas kuliner! 😂🥣';
      }
      if (lower.contains('sakit') || lower.contains('bantuan') || lower.contains('surat') || lower.contains('rt')) {
        return 'Surat pengantar RT aman, nanti saya stempel basah. Istirahat dulu yang bener ya warga, kesehatanmu loh! Butuh apa-apa kabarin saya 🤝';
      }
      
      final rtReplies = [
        'Laporan diterima! Saya pantau terus kondisi Warung Circle. Tetap jaga kerukunan ya, jangan bikin ricuh di posko 👮‍♂️',
        'Iya warga, ada keluhan apa lagi? Pak RT dengerin, tapi inget besok pagi ada kerja bakti bersihin selokan warkop ya! 🧹',
        'Siap! Selama iuran bulanan lancar, keluhan warga pasti diproses secepatnya. Ada yang bisa dibantu lagi? 😉',
      ];
      return rtReplies[DateTime.now().millisecond % rtReplies.length];
    } 
    
    else { // Kucing Warung
      if (lower.contains('makan') || lower.contains('ikan') || lower.contains('lele') || lower.contains('laper') || lower.contains('whiskas')) {
        return 'Meooong! 🐟 (Kucing Warung langsung terbangun, melingkar di kaki lo sambil meong kencang minta lele goreng warkop! Nyamm!)';
      }
      if (lower.contains('elus') || lower.contains('sayang') || lower.contains('imut') || lower.contains('lucu')) {
        return 'Purrr... 💤 (Kucing Warung merem melek keenakan dielus kepalanya, lalu mendengkur pelan di pangkuan lo)';
      }
      if (lower.contains('hus') || lower.contains('pergi') || lower.contains('nakal')) {
        return 'Hisshh! 🐱 (Kucing Warung pasang muka cemberut, ngibasin ekornya dengan angkuh lalu pergi mencari meja lain)';
      }

      final catReplies = [
        'Meoong... 🐱 (Kucing Warung natap lo dengan mata bulat besarnya, seolah-olah ngerti curhatan lo tapi nunggu disogok makanan)',
        'Ngeong! 🐾 (Kucing Warung mencakar-cakar pelan sandal lo, ngajakin main)',
        'Purrr... Meow! (Kucing Warung bobo siang di samping cangkir kopi lo, damai banget)',
      ];
      return catReplies[DateTime.now().millisecond % catReplies.length];
    }
  }
}

class _TypingDot extends StatefulWidget {
  final int index;
  const _TypingDot({required this.index});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: WC.primary.withOpacity(0.3 + (_controller.value * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
