import 'package:flutter/material.dart';
import 'package:spending_share/models/data/group_data.dart';

import 'currency_change_notifier.dart';

class CreateGroupChangeNotifier extends CreateChangeNotifier {
  CreateGroupChangeNotifier() : super(null, null);

  String? _adminId;
  IconData? _icon;
  final List<String> _members = [];
  bool _disposed = false;

  String get adminId => _adminId!;

  get icon => _icon;

  List<String> get members => _members;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void init(GroupData groupData, String? memberName, String adminId) {
    setColorNoNotify(groupData.color);
    setCurrencyNoNotify(groupData.currency);
    if (memberName != null) _members.add(memberName);
    _icon = groupData.icon;
    _adminId = adminId;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  setAdminId(String adminId) {
    _adminId = adminId;
  }

  addMember(String memberName) {
    _members.add(memberName);
    notifyListeners();
  }

  removeMember(int index) {
    members.removeAt(index);
    notifyListeners();
  }

  setIcon(IconData iconData) {
    _icon = iconData;
    notifyListeners();
  }

  bool validateFirstPage() {
    if (name?.isEmpty ?? true) return false;
    if (color == null) return false;
    if (_icon == null) return false;
    if (currency == null) return false;
    return true;
  }
}
