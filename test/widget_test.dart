// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agrivision/controllers/dashboard_controller.dart';
import 'package:agrivision/views/dashboard_view.dart';

void main() {
  testWidgets('affiche le tableau de bord Agrivision', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: DashboardView(controller: DashboardController())),
    );

    expect(find.text('AGRIVISION'), findsOneWidget);
    expect(find.text('Bonjour, agriculteur'), findsOneWidget);
    expect(find.text('Ajouter une activité'), findsOneWidget);
  });

  test('le contrôleur change de section', () {
    final controller = DashboardController();

    controller.selectSection(1);

    expect(controller.selectedIndex, 1);
    controller.dispose();
  });
}
