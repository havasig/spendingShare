import 'package:flutter/material.dart';

import 'currency_change_notifier.dart';

class CreateGroupChangeNotifier extends CreateChangeNotifier {
  CreateGroupChangeNotifier(
    this._adminId,
    _currency,
    this._colorName,
    this._color,
    this._iconName,
    this._icon,
  ) : super(_currency);

  final String _adminId;
  String? _colorName;
  MaterialColor? _color;
  String? _iconName;
  IconData? _icon;
  final List<String> _members = [];

  get adminId => _adminId;

  get colorName => _colorName;

  get color => _color;

  get iconName => _iconName;

  get icon => _icon;

  List<String> get members => _members;

  addMember(String memberName) {
    _members.add(memberName);
    notifyListeners();
  }

  removeMember(int index) {
    members.removeAt(index);
    notifyListeners();
  }

  setColor(String colorName, MaterialColor color) {
    _colorName = colorName;
    _color = color;
    notifyListeners();
  }

  setIcon(String iconName, IconData iconData) {
    _iconName = iconName;
    _icon = iconData;
    notifyListeners();
  }

  bool validateFirstPage() {
    if (name?.isEmpty ?? true) return false;
    if (_colorName?.isEmpty ?? true) return false;
    if (_color == null) return false;
    if (_iconName?.isEmpty ?? true) return false;
    if (_icon == null) return false;
    if (currency == null) return false;
    return true;
  }
}
