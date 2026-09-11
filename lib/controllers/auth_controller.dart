import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> submit({
    required String email,
    required String password,
    required bool register,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (register) {
        await _service.register(email: email, password: password);
      } else {
        await _service.signIn(email: email, password: password);
      }
      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage = switch (error.code) {
        'invalid-credential' ||
        'wrong-password' => 'Email ou mot de passe incorrect.',
        'email-already-in-use' => 'Cette adresse email est déjà utilisée.',
        'weak-password' =>
          'Le mot de passe doit contenir au moins 6 caractères.',
        'invalid-email' => 'Adresse email invalide.',
        'operation-not-allowed' =>
          'La connexion email n’est pas activée dans Firebase.',
        'network-request-failed' => 'Connexion Internet impossible. Réessayez.',
        _ => 'Impossible de se connecter. Vérifiez votre connexion.',
      };
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
