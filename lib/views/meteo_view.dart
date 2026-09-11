import 'package:flutter/material.dart';

import '../services/weather_service.dart';
import '../utils/user_error_message.dart';

class MeteoView extends StatefulWidget {
  const MeteoView({super.key});

  @override
  State<MeteoView> createState() => _MeteoViewState();
}

class _MeteoViewState extends State<MeteoView> {
  final _service = WeatherService();
  WeatherSnapshot? _weather;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Météo')),
    body: Center(
      child: _loading
          ? const CircularProgressIndicator()
          : _error != null
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Text(_error!, textAlign: TextAlign.center),
            )
          : _weather == null
          ? const Text('Aucune donnée météo.')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_sunny_outlined, size: 64),
                Text(
                  '${_weather!.temperature.toStringAsFixed(1)} °C',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(_weather!.description),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualiser'),
                ),
              ],
            ),
    ),
  );

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final weather = await _service.current(
        latitude: -4.325,
        longitude: 15.322,
      );
      if (mounted) setState(() => _weather = weather);
    } catch (error) {
      if (mounted) {
        setState(() => _error = userErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
