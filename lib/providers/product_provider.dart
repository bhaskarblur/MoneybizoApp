import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  dynamic _categories;
  dynamic get categories => _categories;

  changeCategories(dynamic value) {
    _categories = value;
    notifyListeners();
  }

  clearCategories() {
    _categories = null;
    notifyListeners();
  }

  dynamic _searchedCategories;
  dynamic get searchedCategories => _searchedCategories;

  changeSearchedCategories(dynamic value) {
    _searchedCategories = [];
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i]['cat_name']
          .toLowerCase()
          .contains(value.toLowerCase())) {
        _searchedCategories.add(_categories[i]);
      }
    }
    notifyListeners();
  }

  clearSearchedCategories() {
    _searchedCategories = null;
    notifyListeners();
  }

  dynamic _companies;
  dynamic get companies => _companies;

  changeCompanies(dynamic value) {
    _companies = value;
    notifyListeners();
  }

  clearCompanies() {
    _companies = null;
    notifyListeners();
  }

  dynamic _searchedCompanies;
  dynamic get searchedCompanies => _searchedCompanies;

  changeSearchedCompanies(dynamic value) {
    _searchedCompanies = [];
    print(companies.length);
    for (int i = 0; i < _companies.length; i++) {
      print(_companies[i]['gen_company_name']);
      if (_companies[i]['gen_company_name']
          .toLowerCase()
          .contains(value.toLowerCase())) {
        _searchedCompanies.add(_companies[i]);
      }
    }
    notifyListeners();
  }

  clearSearchedCompanies() {
    _searchedCompanies = null;
    notifyListeners();
  }

  dynamic _products;
  dynamic get products => _products;

  changeProducts(dynamic value) {
    _products = value;
    notifyListeners();
  }

  clearProducts() {
    _products = null;
    notifyListeners();
  }

  dynamic _selectedCategoryProduct;
  dynamic get selectedCategoryProduct => _selectedCategoryProduct;

  chnageSelectedCategoryProducts(dynamic value) {
    _selectedCategoryProduct = value;
    notifyListeners();
  }

  clearSelectedCategoryProducts() {
    _selectedCategoryProduct = null;
    notifyListeners();
  }
}
