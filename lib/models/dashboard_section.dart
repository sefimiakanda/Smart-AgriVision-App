import 'package:flutter/material.dart';

class DashboardSection {
  const DashboardSection({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const dashboardSections = [
  DashboardSection(label: 'Accueil', icon: Icons.home_outlined),
  DashboardSection(label: 'Parcelles', icon: Icons.landscape_outlined),
  DashboardSection(label: 'Carnet', icon: Icons.menu_book_outlined),
  DashboardSection(label: 'Diagnostic', icon: Icons.biotech_outlined),
  DashboardSection(label: 'Météo', icon: Icons.cloud_outlined),
  DashboardSection(label: 'NDVI', icon: Icons.satellite_alt_outlined),
  DashboardSection(label: 'Assistant', icon: Icons.chat_bubble_outline),
];
