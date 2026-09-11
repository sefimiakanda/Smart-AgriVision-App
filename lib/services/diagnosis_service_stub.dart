import '../models/diagnostic_model.dart';

class DiagnosisService {
  Future<DiagnosticResult> diagnose(String imagePath) {
    throw UnsupportedError(
      'Le diagnostic TFLite est disponible sur Android et desktop, pas sur Web.',
    );
  }
}
