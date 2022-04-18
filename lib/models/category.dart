import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String? icon;
  List<dynamic>? transactions = [];

  Category({
    required this.name,
    this.icon,
    this.transactions,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Category(
      name: doc.data()?['name'],
      icon: doc.data()?['icon'],
      transactions: doc.data()?['transactions'],
    );
  }
}
