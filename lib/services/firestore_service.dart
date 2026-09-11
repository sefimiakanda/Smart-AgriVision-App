import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/activite_model.dart';
import '../models/parcelle_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId =>
      _auth.currentUser?.uid ?? (throw StateError('Utilisateur non connecté'));

  CollectionReference<Map<String, dynamic>> get _parcelles =>
      _firestore.collection('users').doc(_userId).collection('parcelles');

  CollectionReference<Map<String, dynamic>> get _activites =>
      _firestore.collection('users').doc(_userId).collection('carnet');

  Stream<List<Parcelle>> watchParcelles() => _parcelles.snapshots().map(
    (snapshot) => snapshot.docs.map(Parcelle.fromFirestore).toList(),
  );

  Future<void> addParcelle(Parcelle parcelle) =>
      _parcelles.add(parcelle.toFirestore());

  Stream<List<Activite>> watchActivites() => _activites
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Activite.fromFirestore).toList());

  Future<void> addActivite(Activite activite) =>
      _activites.add(activite.toFirestore());
}
