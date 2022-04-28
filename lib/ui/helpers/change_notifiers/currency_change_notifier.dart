import 'package:flutter/material.dart';

class CreateChangeNotifier extends ChangeNotifier {
  CreateChangeNotifier(this._currency, this._color);

  String? _currency;
  String? _defaultCurrency;
  String? _name;
  double? _exchangeRate;
  MaterialColor? _color;

  double? get exchangeRate => _exchangeRate;

  String get currency => _currency!;

  String? get defaultCurrency => _defaultCurrency;

  String? get name => _name;

  MaterialColor? get color => _color;

  setColorNoNotify(MaterialColor? color) {
    _color = color;
  }

  setCurrencyNoNotify(String? currency) {
    _currency = currency;
  }

  setCurrency(String? currency) {
    _currency = currency;
    notifyListeners();
  }

  setDefaultCurrency(String defaultCurrency) {
    _defaultCurrency = defaultCurrency;
  }

  setExchangeRate(double? exchangeRate) {
    _exchangeRate = exchangeRate;
  }

  setName(String name) {
    _name = name;
  }

  setColor(MaterialColor? color) {
    _color = color;
    notifyListeners();
  }
}
