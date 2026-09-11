import 'package:flutter/material.dart';

import '../../models/parcelle_model.dart';
import '../../services/firestore_service.dart';

class ParcellesView extends StatefulWidget {
  const ParcellesView({super.key});

  @override
  State<ParcellesView> createState() => _ParcellesViewState();
}

class _ParcellesViewState extends State<ParcellesView> {
  final _service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes parcelles')),
      body: StreamBuilder<List<Parcelle>>(
        stream: _service.watchParcelles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const _MessageState(
              message: 'Impossible de charger les parcelles.',
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final parcelles = snapshot.data ?? const <Parcelle>[];
          if (parcelles.isEmpty) {
            return const _MessageState(message: 'Aucune parcelle enregistrée.');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: parcelles.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final parcelle = parcelles[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.landscape_outlined),
                ),
                title: Text(
                  parcelle.nom,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${parcelle.culture} • ${parcelle.superficie.toStringAsFixed(2)} ha',
                ),
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
    final nameController = TextEditingController();
    final cropController = TextEditingController();
    final areaController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nouvelle parcelle'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: _required,
              ),
              TextFormField(
                controller: cropController,
                decoration: const InputDecoration(labelText: 'Culture'),
                validator: _required,
              ),
              TextFormField(
                controller: areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Superficie (ha)'),
                validator: _required,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await _service.addParcelle(
                Parcelle(
                  id: '',
                  nom: nameController.text.trim(),
                  culture: cropController.text.trim(),
                  superficie: double.tryParse(areaController.text) ?? 0,
                  latitude: 0,
                  longitude: 0,
                ),
              );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    nameController.dispose();
    cropController.dispose();
    areaController.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ obligatoire' : null;
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}
