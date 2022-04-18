import 'package:flutter/material.dart';

class CreateGroupChangeNotifier extends ChangeNotifier {
  CreateGroupChangeNotifier(this._adminId, this._currency, this._colorName, this._color, this._iconName, this._icon);

  final String _adminId;

  get adminId => _adminId;

  String? _name;

  get name => _name;

  String? _currency;

  get currency => _currency;

  String? _colorName;

  get colorName => _colorName;

  MaterialColor? _color;

  get color => _color;

  String? _iconName;

  get iconName => _iconName;

  IconData? _icon;

  get icon => _icon;

  final List<String> _members = [];

  List<String> get members => _members;

  addMember(String memberName) {
    _members.add(memberName);
    notifyListeners();
  }

  removeMember(int index) {
    members.removeAt(index);
    notifyListeners();
  }

  setName(String name) {
    _name = name;
    notifyListeners();
  }

  setCurrency(String currency) {
    _currency = currency;
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
    if (_name?.isEmpty ?? true) return false;
    if (_currency?.isEmpty ?? true) return false;
    if (_colorName?.isEmpty ?? true) return false;
    if (_color == null) return false;
    if (_iconName?.isEmpty ?? true) return false;
    if (_icon == null) return false;
    return true;
  }
}
