import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthController _controller;
  bool _register = false;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.eco, size: 64, color: Color(0xFF1B5E20)),
                    const SizedBox(height: 16),
                    Text(
                      'AGRIVISION RDC',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _register
                          ? 'Créez votre compte agricole'
                          : 'Connectez-vous à votre espace',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_controller.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _controller.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _controller.isLoading ? null : _submit,
                      icon: _controller.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: Text(
                        _register ? 'Créer le compte' : 'Se connecter',
                      ),
                    ),
                    TextButton(
                      onPressed: _controller.isLoading
                          ? null
                          : () => setState(() => _register = !_register),
                      child: Text(
                        _register ? 'J’ai déjà un compte' : 'Créer un compte',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.length < 6) {
      setState(
        () => _controller.errorMessage =
            'Saisissez un email et un mot de passe de 6 caractères minimum.',
      );
      return;
    }
    final success = await _controller.submit(
      email: email,
      password: password,
      register: _register,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardView(controller: DashboardController()),
        ),
      );
    }
  }
}
