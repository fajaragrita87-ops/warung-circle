import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  // Read Gemini API Key from environment define
  static const String _geminiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Generate cerita lebay / lucu for "Titip Cerita" using Gemini 2.5 Flash
  Future<String> generateTitipCerita(String prompt) async {
    if (_geminiKey.isNotEmpty) {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_geminiKey');

      final systemPrompt = "Buat teks '发疯文学' (copypasta lebay/lucu dramatis) bahasa Indonesia tentang topik yang diinput warga. "
          "Maksimal 3 paragraf. Gaya bahasa harus sangat lebay, heboh, dramatis, kocak, khas Gen Z/warganet Indonesia. "
          "Jangan mengandung SARA, kekerasan, atau pornografi.";

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "$systemPrompt\n\nTopik curhatan warga: \"$prompt\"\nCerita Dramatis:"}
            ]
          }
        ]
      });

      try {
        final resp = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        ).timeout(const Duration(seconds: 15));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);
          final text = data['candidates']?[0]['content']?['parts']?[0]['text'] as String?;
          if (text != null && text.trim().isNotEmpty) {
            return text.trim();
          }
        }
      } catch (e) {
        debugPrint("Error generating story via Gemini: $e");
      }
    }

    // Local stub fallback
    await Future.delayed(const Duration(seconds: 2));
    return 'Duh, bro... Jadi ceritanya: "$prompt" — beneran deh, ini kisahnya berakhir dramatis! Gue langsung lari ke warkop Teh Erni sambil nangis guling-guling, terus seisi warkop ngeliatin gue dikira kesurupan reog. Pelajaran hari ini: jangan pernah curhat pas perut kosong!';
  }

  /// AI content check filter (checks for toxicity/banned words)
  Future<bool> checkContent(String text) async {
    if (_geminiKey.isNotEmpty) {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_geminiKey');

      final systemPrompt = "Cek teks berikut ini apakah mengandung ujaran kebencian, SARA kasar, pornografi, atau toxic abuse tingkat parah? "
          "Jawab HANYA satu kata: 'YA' atau 'TIDAK'.";

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "$systemPrompt\n\nTeks untuk dicek: \"$text\"\nJawaban:"}
            ]
          }
        ]
      });

      try {
        final resp = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        ).timeout(const Duration(seconds: 5));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);
          final answer = data['candidates']?[0]['content']?['parts']?[0]['text'] as String?;
          if (answer != null) {
            return !answer.toUpperCase().contains('YA');
          }
        }
      } catch (e) {
        debugPrint("Error checking content via Gemini: $e");
      }
    }

    // Default allow if error or key missing
    return true;
  }

  /// Generate sassy reply from Teh Erni AI based on comment/post content
  Future<String> generateTehErniReply(String userComment) async {
    if (_geminiKey.isNotEmpty) {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_geminiKey');

      final systemPrompt = "Kamu adalah Teh Erni, tante pemilik warkop paling sassy di Warung Circle. "
          "Gaya bicaramu sangat gaul, ramah tapi pedas (sassy), kocak, layaknya tante-tante warkop Indonesia yang tahu segalanya tentang gosip kampung digital. "
          "Gunakan slang gaul Indonesia (e.g. ngab, bestie, sirkel, drama, kasbon, kopi, dll.). "
          "Balaslah pesan warga warkop secara singkat (maksimal 2 kalimat) dengan nada sassy/lucu.";

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "$systemPrompt\n\nKomentar Warga: \"$userComment\"\nTeh Erni menjawab:"}
            ]
          }
        ]
      });

      try {
        final resp = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        ).timeout(const Duration(seconds: 8));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);
          final text = data['candidates']?[0]['content']?['parts']?[0]['text'] as String?;
          if (text != null && text.trim().isNotEmpty) {
            return text.trim();
          }
        }
      } catch (e) {
        debugPrint("Error generating Erni reply via Gemini: $e");
      }
    }

    // Default sassy replies
    final List<String> defaultReplies = [
      "Sendirian lagi ngab? 😏",
      "Itu keliatan enak banget sih, mau dong dibagikan di Dapur 🍵",
      "Drama sirkel apalagi ini ya ampun... 👀",
      "Kasbon dulu gak sih ngab biar anget? 😂",
      "Mending lu traktir kopi gue aja dah wkwk ☕",
      "Sassy bener komennya, wkwk relate tapi! 💅",
    ];
    return defaultReplies[DateTime.now().millisecond % defaultReplies.length];
  }
}
