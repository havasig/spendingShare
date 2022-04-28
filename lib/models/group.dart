import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class Group {
  String adminId;
  String databaseId;
  List<dynamic> categories;
  MaterialColor color;
  String currency;
  IconData icon;
  List<dynamic> members;
  String name;
  List<dynamic> transactions;
  List<dynamic> debts;

  Group({
    required this.databaseId,
    required this.adminId,
    required this.categories,
    required this.color,
    required this.currency,
    required this.icon,
    required this.members,
    required this.name,
    required this.transactions,
    required this.debts,
  });

  factory Group.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Group(
      databaseId: doc.id,
      adminId: doc.data()?['adminId'],
      categories: doc.data()?['categories'],
      color: globals.colors[doc.data()?['color']] ?? globals.colors['default']!,
      currency: doc.data()?['currency'],
      icon: globals.icons[doc.data()?['icon']] ?? globals.icons['default']!,
      members: doc.data()?['members'],
      name: doc.data()?['name'],
      transactions: doc.data()?['transactions'],
      debts: doc.data()?['debts'],
    );
  }
}
