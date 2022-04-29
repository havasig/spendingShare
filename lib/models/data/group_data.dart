import 'package:flutter/material.dart';

class GroupData {
  GroupData({required this.groupId, required this.color, this.currency, required this.icon});

  String groupId;
  MaterialColor color;
  IconData icon;
  String? currency;
}
