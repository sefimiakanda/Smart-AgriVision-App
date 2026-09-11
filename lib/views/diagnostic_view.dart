import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/diagnosis_service.dart';

class DiagnosticView extends StatefulWidget {
  const DiagnosticView({super.key});

  @override
  State<DiagnosticView> createState() => _DiagnosticViewState();
}

class _DiagnosticViewState extends State<DiagnosticView> {
  final _picker = ImagePicker();
  final _service = DiagnosisService();
  XFile? _image;
  String? _result;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostic IA')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_image != null)
            Image.file(File(_image!.path), height: 260, fit: BoxFit.cover),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _chooseImage,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Choisir une photo'),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_result != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety_outlined),
                title: const Text('Résultat'),
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
  }

  Future<void> _chooseImage() async {
    final image =
        await _picker.pickImage(source: ImageSource.camera) ??
        await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = image;
      _loading = true;
      _result = null;
      _error = null;
    });
    try {
      final result = await _service.diagnose(image.path);
      if (mounted) {
        setState(
          () => _result =
              '${result.label} (${(result.confidence * 100).toStringAsFixed(1)} %)',
        );
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error.toString().replaceFirst('Bad state: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
