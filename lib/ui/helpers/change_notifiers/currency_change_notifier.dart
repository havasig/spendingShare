import 'package:flutter/material.dart';

class CreateChangeNotifier extends ChangeNotifier {
  CreateChangeNotifier(this._currency);

  String? _currency;
  String? _defaultCurrency;
  String? _name;
  double? _exchangeRate;

  double? get exchangeRate => _exchangeRate;

  String get currency => _currency!;

  String get defaultCurrency => _defaultCurrency!;

  String? get name => _name;

  setCurrency(String? currency) {
    _currency = currency;
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
}
