import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'views/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AgrivisionApp());
}

class AgrivisionApp extends StatelessWidget {
  const AgrivisionApp({super.key});

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
      home: const AuthGate(),
    );
  }
}
