import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  chnageLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
