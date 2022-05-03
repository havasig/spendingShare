import 'package:flutter/material.dart';

class SelectIconChangeNotifier extends ChangeNotifier {
  SelectIconChangeNotifier();

  IconData? icon;

  setIcon(IconData? iconn) {
    icon = iconn;
    notifyListeners();
  }
}
