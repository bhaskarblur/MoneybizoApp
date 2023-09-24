import 'package:flutter/material.dart';

class DownloadProgress with ChangeNotifier {
  String _loader = '0';
  String get loader => _loader;

  changeLoader(String value) {
    _loader = value;
    notifyListeners();
  }
}
