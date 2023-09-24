import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
