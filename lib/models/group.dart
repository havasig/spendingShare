import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String adminId;
  String databaseId;
  List<String> categories;
  String color;
  String defaultCurrency;
  String icon;
  List<String> members;
  String name;
  List<String> transactions;
  List<String> debts;

  Group({
    required this.databaseId,
    required this.adminId,
    required this.categories,
    required this.color,
    required this.defaultCurrency,
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
      adminId: doc.data()?['adminId'] ?? '',
      categories: (doc.data()?['categories'] ?? []).map<String>((categories) => categories.id.toString()).toList() ?? [],
      color: doc.data()?['color'] ?? '',
      defaultCurrency: doc.data()?['defaultCurrency'] ?? '',
      icon: doc.data()?['icon'] ?? '',
      members: (doc.data()?['members'] ?? []).map<String>((member) => member.id.toString()).toList() ?? [],
      name: doc.data()?['name'] ?? '',
      transactions: (doc.data()?['transactions'] ?? []).map<String>((transactions) => transactions.id.toString()).toList() ?? [],
      debts: (doc.data()?['debts'] ?? []).map<String>((debts) => debts.id.toString()).toList() ?? [],
    );
  }
}
