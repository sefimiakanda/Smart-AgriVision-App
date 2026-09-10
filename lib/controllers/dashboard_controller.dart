import 'package:flutter/foundation.dart';

class DashboardController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectSection(int index) {
    if (index == _selectedIndex) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }
}
