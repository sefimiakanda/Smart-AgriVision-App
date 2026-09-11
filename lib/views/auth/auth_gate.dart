import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/dashboard_controller.dart';
import '../../services/auth_service.dart';
import '../dashboard_view.dart';
import 'login_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, this._service});

  final AuthService? _service;

  @override
  Widget build(BuildContext context) {
    final authService = _service ?? AuthService();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == null) {
          return const LoginView();
        }
        return DashboardView(controller: DashboardController());
      },
    );
  }
}
