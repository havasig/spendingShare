import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class Category {
  String name;
  IconData? icon;
  String databaseId;
  List<dynamic> transactions = [];

  Category({
    required this.name,
    this.icon,
    required this.databaseId,
    required this.transactions,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Category(
      name: doc.data()?['name'],
      databaseId: doc.id,
      icon: globals.icons[doc.data()?['icon']],
      transactions: doc.data()?['transactions'],
    );
  }
}
