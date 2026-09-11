import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'views/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? firebaseError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    firebaseError = error;
  }
  runApp(AgrivisionApp(firebaseError: firebaseError));
}

class AgrivisionApp extends StatelessWidget {
  const AgrivisionApp({super.key, this.firebaseError});

  final Object? firebaseError;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1B5E20);
    return MaterialApp(
      title: 'Agrivision RDC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7F8F3),
        useMaterial3: true,
      ),
      home: firebaseError == null
          ? const AuthGate()
          : FirebaseErrorView(error: firebaseError!),
    );
  }
}

class FirebaseErrorView extends StatelessWidget {
  const FirebaseErrorView({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Connexion au service indisponible',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Vérifiez la connexion Internet et la configuration Firebase.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
