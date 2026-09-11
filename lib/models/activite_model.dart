import 'package:cloud_firestore/cloud_firestore.dart';

class Activite {
  const Activite({
    required this.id,
    required this.type,
    required this.parcelleId,
    required this.date,
    required this.description,
  });

  final String id;
  final String type;
  final String parcelleId;
  final DateTime date;
  final String description;

  factory Activite.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final timestamp = data['date'];
    return Activite(
      id: snapshot.id,
      type: data['type'] as String? ?? 'Autre',
      parcelleId: data['parcelleId'] as String? ?? '',
      date: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      description: data['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'type': type,
    'parcelleId': parcelleId,
    'date': Timestamp.fromDate(date),
    'description': description,
  };
}
