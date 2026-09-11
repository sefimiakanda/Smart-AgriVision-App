import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/diagnostic_model.dart';

class DiagnosisService {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<DiagnosticResult> diagnose(String imagePath) async {
    final interpreter = await _loadInterpreter();
    final labels = await _loadLabels();
    final source = image_lib.decodeImage(await File(imagePath).readAsBytes());
    if (source == null) throw StateError('Image invalide.');

    final inputShape = interpreter.getInputTensor(0).shape;
    if (inputShape.length != 4 || inputShape[3] != 3) {
      throw StateError('Format d’entrée TFLite non pris en charge.');
    }
    final resized = image_lib.copyResize(
      source,
      width: inputShape[2],
      height: inputShape[1],
    );
    final input = [
      for (var y = 0; y < inputShape[1]; y++)
        [
          for (var x = 0; x < inputShape[2]; x++)
            [
              resized.getPixel(x, y).r / 255.0,
              resized.getPixel(x, y).g / 255.0,
              resized.getPixel(x, y).b / 255.0,
            ],
        ],
    ];
    final outputShape = interpreter.getOutputTensor(0).shape;
    final output = _nestedList(outputShape);
    interpreter.run([input], output);
    final scores = _flatten(
      output,
    ).map((value) => (value as num).toDouble()).toList();
    var bestIndex = 0;
    for (var index = 1; index < scores.length; index++) {
      if (scores[index] > scores[bestIndex]) bestIndex = index;
    }
    return DiagnosticResult(
      label: bestIndex < labels.length
          ? _friendlyLabel(labels[bestIndex])
          : 'Classe inconnue',
      confidence: scores.isEmpty ? 0 : scores[bestIndex],
    );
  }

  Future<Interpreter> _loadInterpreter() async {
    return _interpreter ??= await Interpreter.fromAsset(
      'assets/leaf_disease_model.tflite',
    );
  }

  Future<List<String>> _loadLabels() async {
    if (_labels != null) return _labels!;
    final content = await rootBundle.loadString('assets/class_names.json');
    final json = jsonDecode(content) as Map<String, dynamic>;
    return _labels = (json['class_names'] as List<dynamic>).cast<String>();
  }

  List<dynamic> _nestedList(List<int> shape) {
    if (shape.length == 1) return List<double>.filled(shape.first, 0);
    return List.generate(shape.first, (_) => _nestedList(shape.sublist(1)));
  }

  Iterable<dynamic> _flatten(dynamic value) sync* {
    if (value is List) {
      for (final item in value) {
        yield* _flatten(item);
      }
    } else {
      yield value;
    }
  }

  String _friendlyLabel(String label) => label
      .replaceAll('___', ' : ')
      .replaceAll('_', ' ')
      .replaceAll('healthy', 'sain')
      .replaceAll('Apple', 'Pommier')
      .replaceAll('Corn', 'Maïs')
      .replaceAll('Tomato', 'Tomate')
      .replaceAll('Potato', 'Pomme de terre');
}
