import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class Member {
  String name;
  String? userFirebaseId;
  String? databaseId;
  IconData? icon;
  List<dynamic> transactions = [];

  Member({
    required this.name,
    this.databaseId,
    this.userFirebaseId,
    this.icon,
    required this.transactions,
  });

  factory Member.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Member(
      databaseId: doc.id,
      name: doc.data()?['name'],
      userFirebaseId: doc.data()?['userFirebaseId'],
      icon: globals.icons[doc.data()?['icon']],
      transactions: doc.data()?['transactions'],
    );
  }
}
