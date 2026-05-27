import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // Provide an HF API key via --dart-define=HF_API_KEY=your_token
  static const String _hfKey = String.fromEnvironment('HF_API_KEY');
  static const String _hfModel =
      String.fromEnvironment('HF_MODEL', defaultValue: 'gpt2');

  /// Generate cerita: use Hugging Face Inference if `_hfKey` is provided,
  /// otherwise fall back to the local stub.
  Future<String> generateTitipCerita(String prompt) async {
    if (_hfKey.isNotEmpty) {
      return await _generateViaHuggingFace(prompt);
    }

    // Local stub
    await Future.delayed(const Duration(seconds: 2));
    return 'Duh, bro... Jadi ceritanya: "$prompt" — beneran deh, ini kisahnya berakhir dengan segelas kopi panas, satu pelukan, dan tawa yang gak habis-habis. Bagi yang baca, siapin tisu dan hati yang kuat!';
  }

  Future<bool> checkContent(String text) async {
    // For now always allow; could call moderation endpoint if HF key provided.
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<String> _generateViaHuggingFace(String prompt) async {
    final uri =
        Uri.parse('https://api-inference.huggingface.co/models/$_hfModel');
    final body = jsonEncode({'inputs': prompt});
    final resp = await http
        .post(uri,
            headers: {
              'Authorization': 'Bearer $_hfKey',
              'Content-Type': 'application/json'
            },
            body: body)
        .timeout(const Duration(seconds: 30));

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      // HF returns list or object depending on model; try to extract text
      if (decoded is List &&
          decoded.isNotEmpty &&
          decoded[0]['generated_text'] != null) {
        return decoded[0]['generated_text'] as String;
      }
      if (decoded is Map && decoded['generated_text'] != null) {
        return decoded['generated_text'] as String;
      }
      // Some models return plain text
      return resp.body;
    } else {
      throw Exception('HF Inference failed: ${resp.statusCode} ${resp.body}');
    }
  }
}
