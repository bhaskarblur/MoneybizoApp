import 'package:flutter/material.dart';
import 'package:money_bizo/models/city.dart';

import '../models/suburb.dart';

class CitySuburbProvider with ChangeNotifier {
  final List<City> _city = [];
  List<City> get city => _city;

  addToCity(City value) {
    _city.add(value);
  }

  clearCity() {
    _city.clear();
  }

  final List<Suburb> _suburb = [];
  List<Suburb> get suburb => _suburb;

  addToSuburb(Suburb value) {
    _suburb.add(value);
  }

  clearsuburb() {
    _suburb.clear();
  }

  notify() {
    notifyListeners();
  }
}
