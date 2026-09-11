import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> ask(String question) async {
    const key = String.fromEnvironment('GEMINI_API_KEY');
    if (key.isEmpty) {
      throw StateError(
        'Clé Gemini absente. Lancez avec --dart-define=GEMINI_API_KEY=...',
      );
    }
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$key',
    );
    final response = await _client
        .post(
          uri,
          headers: {'content-type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {
                    'text':
                        'Réponds en français simple, avec prudence agricole : $question',
                  },
                ],
              },
            ],
          }),
        )
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw StateError('Assistant indisponible (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ((((data['candidates'] as List<dynamic>).first
                        as Map<String, dynamic>)['content']
                    as Map<String, dynamic>)['parts']
                as List<dynamic>)
            .first['text']
        as String;
  }
}
