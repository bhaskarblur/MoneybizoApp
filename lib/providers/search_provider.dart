import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  var _searchedPhotos;

  get searchedPhotos => _searchedPhotos;

  changeSearchedPhotos(var value) {
    _searchedPhotos = value;
  }

  removeAllPhotos() {
    _searchedPhotos = null;
  }

  notify() {
    notifyListeners();
  }

  final List<String> _pages = [];
  List<String> get pages => _pages;

  int _totalPage = 0;
  int get totalPage => _totalPage;

  changeTotalPage(int value) {
    _totalPage = value;
    for (int i = 0; i < _totalPage; i++) {
      _pages.add(i.toString());
    }
  }

  String _currentPage = '1';
  String get currentPage => _currentPage;

  changeCurrentPage(String value) {
    _currentPage = value;
  }
}
