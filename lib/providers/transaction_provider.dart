import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  dynamic _transactions;
  dynamic get transactions => _transactions;

  changeTransaction(dynamic value) {
    _transactions = value;
    notifyListeners();
  }

  clearTransactions() {
    _transactions = null;
    notifyListeners();
  }

  dynamic _salesHistory;
  dynamic get salesHistory => _salesHistory;

  changeSalesHistory(dynamic value) {
    _salesHistory = value;
    notifyListeners();
  }

  clearSalesHistory() {
    _salesHistory = null;
    notifyListeners();
  }
}
