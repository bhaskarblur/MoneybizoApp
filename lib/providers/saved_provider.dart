import 'package:flutter/material.dart';

class SavedProvider with ChangeNotifier {
  dynamic _saved;
  dynamic get saved => _saved;

  changeFavorites(dynamic value) {
    _saved = value;
    notifyListeners();
  }

  clearFavorites() {
    _saved = null;
    notifyListeners();
  }
}
