import 'package:flutter/material.dart';

class GroupData {
  GroupData({required this.groupId, required this.color, this.currency, required this.icon, this.name});

  String groupId;
  MaterialColor color;
  IconData? icon;
  String? currency;
  String? name;
}
