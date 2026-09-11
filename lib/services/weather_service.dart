import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherSnapshot {
  const WeatherSnapshot({required this.temperature, required this.description});

  final double temperature;
  final String description;
}

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherSnapshot> current({
    required double latitude,
    required double longitude,
  }) async {
    const key = String.fromEnvironment('OPENWEATHERMAP_API_KEY');
    if (key.isEmpty) {
      throw StateError(
        'Clé météo absente. Lancez avec --dart-define=OPENWEATHERMAP_API_KEY=...',
      );
    }
    final uri = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$key&units=metric&lang=fr',
    );
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw StateError('Météo indisponible (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final weather =
        (data['weather'] as List<dynamic>).first as Map<String, dynamic>;
    return WeatherSnapshot(
      temperature: (data['main']['temp'] as num).toDouble(),
      description: weather['description'] as String? ?? 'Inconnue',
    );
  }
}
