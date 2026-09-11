import 'package:flutter/material.dart';

import '../../models/activite_model.dart';
import '../../services/firestore_service.dart';

class CarnetView extends StatefulWidget {
  const CarnetView({super.key});

  @override
  State<CarnetView> createState() => _CarnetViewState();
}

class _CarnetViewState extends State<CarnetView> {
  final _service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carnet de culture')),
      body: StreamBuilder<List<Activite>>(
        stream: _service.watchActivites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Impossible de charger le carnet.'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final activites = snapshot.data ?? const <Activite>[];
          if (activites.isEmpty) {
            return const Center(child: Text('Aucune activité enregistrée.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: activites.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final activite = activites[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.event_note_outlined),
                ),
                title: Text(
                  activite.type,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${_formatDate(activite.date)}\n${activite.description}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final descriptionController = TextEditingController();
    final parcelController = TextEditingController();
    var selectedType = 'Observation';
    final types = [
      'Semis',
      'Irrigation',
      'Fertilisation',
      'Traitement phytosanitaire',
      'Désherbage',
      'Observation',
      'Récolte',
      'Autre',
    ];
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvelle activité'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: types
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedType = value ?? selectedType),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: parcelController,
                decoration: const InputDecoration(
                  labelText: 'Identifiant de parcelle (optionnel)',
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                await _service.addActivite(
                  Activite(
                    id: '',
                    type: selectedType,
                    parcelleId: parcelController.text.trim(),
                    date: DateTime.now(),
                    description: descriptionController.text.trim(),
                  ),
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
    descriptionController.dispose();
    parcelController.dispose();
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
