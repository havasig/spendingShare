import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String adminId;
  List<String> categories;
  String color;
  String defaultCurrency;
  String icon;
  List<String> members;
  String name;
  List<String> transactions;

  Group({
    required this.adminId,
    required this.categories,
    required this.color,
    required this.defaultCurrency,
    required this.icon,
    required this.members,
    required this.name,
    required this.transactions,
  });

  factory Group.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Group(
      adminId: doc.data()?['adminId'] ?? '',
      categories: [],
      color: doc.data()?['color'] ?? '',
      defaultCurrency: doc.data()?['defaultCurrency'] ?? '',
      icon: doc.data()?['icon'] ?? '',
      members: (doc.data()?['members'] ?? []).map<String>((member) => member.id.toString()).toList() ?? [],
      name: doc.data()?['name'] ?? '',
      transactions: [],
    );
  }
}
