import 'package:cloud_firestore/cloud_firestore.dart';

class Parcelle {
  const Parcelle({
    required this.id,
    required this.nom,
    required this.culture,
    required this.superficie,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String nom;
  final String culture;
  final double superficie;
  final double latitude;
  final double longitude;

  factory Parcelle.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return Parcelle(
      id: snapshot.id,
      nom: data['nom'] as String? ?? '',
      culture: data['culture'] as String? ?? '',
      superficie: (data['superficie'] as num?)?.toDouble() ?? 0,
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'nom': nom,
    'culture': culture,
    'superficie': superficie,
    'latitude': latitude,
    'longitude': longitude,
  };
}
