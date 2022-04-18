import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String adminId;
  String databaseId;
  List<dynamic> categories;
  String color;
  String currency;
  String icon;
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
      // TODO need?
      adminId: doc.data()?['adminId'],
      categories: doc.data()?['categories'],
      color: doc.data()?['color'],
      currency: doc.data()?['currency'],
      icon: doc.data()?['icon'],
      members: doc.data()?['members'],
      name: doc.data()?['name'],
      transactions: doc.data()?['transactions'],
      debts: doc.data()?['debts'],
    );
  }
}
