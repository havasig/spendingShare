import 'package:cloud_firestore/cloud_firestore.dart';

class SpendingShareUser {
  String color;
  String currency;
  List<String>? groups = [];
  String icon;
  String name;
  String userFirebaseId;
  String databaseId;

  SpendingShareUser({
    this.color = '',
    this.currency = '',
    this.groups,
    this.icon = '',
    this.name = '',
    this.userFirebaseId = '',
    this.databaseId = '',
  });

  factory SpendingShareUser.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return SpendingShareUser(
      databaseId: doc.id,
      name: doc.data()?['name'] ?? '',
      color: doc.data()?['color'] ?? '',
      icon: doc.data()?['icon'] ?? '',
      currency: doc.data()?['currency'] ?? '',
      groups: [],
      userFirebaseId: '',
    );
  }
}
