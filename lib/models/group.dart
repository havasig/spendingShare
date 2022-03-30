import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String name;
  String color;
  String icon;
  String defaultCurrency;
  String adminId;
  List<String> memberIds;

  Group({
    required this.name,
    required this.defaultCurrency,
    required this.color,
    required this.icon,
    required this.adminId,
    required this.memberIds,
  });

  factory Group.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Group(
      name: doc.data()?['name'] ?? '',
      color: doc.data()?['color'] ?? '',
      icon: doc.data()?['icon'] ?? '',
      defaultCurrency: doc.data()?['defaultCurrency'] ?? '',
      adminId: doc.data()?['admin'].id ?? '',
      memberIds: (doc.data()?['members'] ?? []).map<String>((member) => member.id.toString()).toList() ?? [],
    );
  }
}
