import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class AssistantView extends StatefulWidget {
  const AssistantView({super.key});

  @override
  State<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  final _questionController = TextEditingController();
  final _service = GeminiService();
  String? _answer;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Assistant agricole')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _answer ?? _error ?? 'Posez une question sur votre culture.',
              ),
            ),
          ),
          TextField(
            controller: _questionController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Votre question',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _ask,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: const Text('Envoyer'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _ask() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _answer = null;
    });
    try {
      final answer = await _service.ask(question);
      if (mounted) setState(() => _answer = answer);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error.toString().replaceFirst('Bad state: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
