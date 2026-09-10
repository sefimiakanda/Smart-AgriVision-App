import 'package:flutter/material.dart';

import 'controllers/dashboard_controller.dart';
import 'views/dashboard_view.dart';

void main() {
  runApp(const AgrivisionApp());
}

class AgrivisionApp extends StatefulWidget {
  const AgrivisionApp({super.key});

  @override
  State<AgrivisionApp> createState() => _AgrivisionAppState();
}

class _AgrivisionAppState extends State<AgrivisionApp> {
  late final DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _dashboardController = DashboardController();
  }

  @override
  void dispose() {
    _dashboardController.dispose();
    super.dispose();
  }

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
      home: DashboardView(controller: _dashboardController),
    );
  }
}
