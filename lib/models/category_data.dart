import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class CategoryData {
  String databaseId;
  String name;
  IconData icon;

  CategoryData({
    required this.databaseId,
    required this.name,
    required this.icon,
  });

  reInit(String newName, IconData newIcon) {
    name = newName;
    icon = newIcon;
  }

  factory CategoryData.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return CategoryData(
      databaseId: doc.id,
      name: doc.data()?['name'],
      icon: globals.icons[doc.data()?['icon']] ?? globals.icons['default']!,
    );
  }
}
