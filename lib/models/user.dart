import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class SpendingShareUser {
  MaterialColor color;
  String currency;
  List<DocumentReference> groups;
  IconData icon;
  String name;
  String userFirebaseId;
  String databaseId;

  SpendingShareUser({
    required this.color,
    this.currency = '',
    required this.icon,
    this.name = '',
    this.userFirebaseId = '',
    this.databaseId = '',
    required this.groups,
  });

  factory SpendingShareUser.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return SpendingShareUser(
      databaseId: doc.id,
      name: doc.data()?['name'],
      color: globals.colors[doc.data()?['color']] ?? globals.colors['default']!,
      icon: globals.icons[doc.data()?['icon']] ?? globals.icons['default']!,
      currency: doc.data()?['currency'],
      userFirebaseId: doc.data()?['userFirebaseId'],
      groups: doc.data()?['groups'],
    );
  }
}
