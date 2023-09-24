import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  dynamic _profile;
  dynamic get profile => _profile;

  changeProfile(dynamic value) {
    _profile = value;
    notifyListeners();
  }

  dynamic _balance;
  dynamic get balance => _balance;

  changeBalance(dynamic value) {
    _balance = value;
    notifyListeners();
  }

  dynamic _bankDetails;
  dynamic get bankDetails => _bankDetails;

  changeBankDetails(dynamic value) {
    _bankDetails = value;
    notifyListeners();
  }

  bool _company = false;
  bool get company => _company;

  changeCompany(bool value) {
    _company = value;
    notifyListeners();
  }
}
