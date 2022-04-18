import 'package:flutter/material.dart';

class CreateChangeNotifier extends ChangeNotifier {
  CreateChangeNotifier(this._currency);
  String? _currency;
  String? _name;

  get currency => _currency;
  get name => _name;

  setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }
}
