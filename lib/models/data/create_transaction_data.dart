import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class CreateTransactionData {
  DocumentReference? _category;
  DocumentReference? _member;
  String? _groupId;
  final Set<DocumentReference> _allMembers = {};
  MaterialColor _color = globals.colors['default']!;
  IconData _groupIcon = globals.icons['default']!;

  DocumentReference? get category => _category;

  String? get groupId => _groupId;

  MaterialColor get color => _color;

  IconData get groupIcon => _groupIcon;

  DocumentReference? get member => _member;

  Set<DocumentReference> get allMembers => _allMembers;

  setGroupId(String groupId) {
    _groupId = groupId;
  }

  setAllMembers(List<DocumentReference> allMembers) {
    _allMembers.clear();
    _allMembers.addAll(allMembers);
  }

  clearAllMembers() {
    _allMembers.clear();
  }

  addToAllMembers(DocumentReference item) {
    _allMembers.add(item);
  }

  setColor(MaterialColor color) {
    _color = color;
  }

  setGroupIcon(IconData groupIcon) {
    _groupIcon = groupIcon;
  }

  setCategory(DocumentReference category) {
    _category = category;
  }

  setMember(DocumentReference member) {
    _member = member;
  }

  clear() {
    _category = null;
    _member = null;
    _allMembers.clear();
    _groupId = null;
    _color = globals.colors['default']!;
    _groupIcon = globals.icons['default']!;
  }

  String? validateMember() {
    if (_member == null) {
      return 'member_cannot_be_empty'.tr;
    }
    return null;
  }

  String? validateCategory() {
    if (_category == null) {
      return 'category_cannot_be_empty'.tr;
    }
    return null;
  }
}
