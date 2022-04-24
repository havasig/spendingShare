import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String? icon;
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
      icon: doc.data()?['icon'],
      transactions: doc.data()?['transactions'],
    );
  }
}
