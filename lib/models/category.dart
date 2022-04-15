import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String databaseId;
  String name;
  String? userFirebaseId;
  String icon;
  List<String>? transactions = [];

  Category({
    this.databaseId = '',
    this.name = '',
    this.userFirebaseId = '',
    this.icon = '',
    this.transactions,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Category(
      databaseId: doc.id,
      name: doc.data()?['name'] ?? '',
      userFirebaseId: doc.data()?['userFirebaseId'],
      icon: doc.data()?['icon'],
      transactions: [],
    );
  }
}
