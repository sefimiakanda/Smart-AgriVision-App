import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

class NdviService {
  NdviService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  double radiusMeters(double areaHectares) =>
      math.sqrt(areaHectares * 10000 / math.pi);

  Future<double> fetchNdvi({
    required double latitude,
    required double longitude,
    required double areaHectares,
  }) async {
    const key = String.fromEnvironment('AGROMONITORING_API_KEY');
    if (key.isEmpty) {
      throw StateError(
        'Clé NDVI absente. Lancez avec --dart-define=AGROMONITORING_API_KEY=...',
      );
    }
    final radius = radiusMeters(areaHectares);
    final uri = Uri.parse(
      'https://api.agromonitoring.com/1.0/ndvi/history?lat=$latitude&lon=$longitude&radius=$radius&appid=$key',
    );
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw StateError('NDVI indisponible (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) throw StateError('Aucune donnée NDVI disponible.');
    return (data.last as Map<String, dynamic>)['data'] as double? ?? 0;
  }
}
