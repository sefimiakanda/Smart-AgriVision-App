import 'package:flutter/material.dart';

import '../services/ndvi_service.dart';
import '../utils/user_error_message.dart';

class NdviView extends StatefulWidget {
  const NdviView({super.key});

  @override
  State<NdviView> createState() => _NdviViewState();
}

class _NdviViewState extends State<NdviView> {
  final _areaController = TextEditingController(text: '1');
  final _service = NdviService();
  double? _radius;
  String? _result;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Suivi NDVI')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: _areaController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Superficie (ha)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.satellite_alt_outlined),
          label: const Text('Analyser la parcelle'),
        ),
        if (_radius != null)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Rayon approximatif : ${_radius!.toStringAsFixed(1)} m',
            ),
          ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_result != null)
          Card(
            child: ListTile(
              title: const Text('Indice NDVI'),
              subtitle: Text(_result!),
            ),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    ),
  );

  Future<void> _load() async {
    final area = double.tryParse(_areaController.text);
    if (area == null || area <= 0) {
      setState(() => _error = 'Saisissez une superficie valide.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _radius = _service.radiusMeters(area);
    });
    try {
      final value = await _service.fetchNdvi(
        latitude: -4.325,
        longitude: 15.322,
        areaHectares: area,
      );
      if (mounted) setState(() => _result = value.toStringAsFixed(3));
    } catch (error) {
      if (mounted) {
        setState(() => _error = userErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
