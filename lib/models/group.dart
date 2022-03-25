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

  // TODO fix group read (admin and memebers reference)
  factory Group.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    //var a = doc.data()?['admin']?.get();
    //var b = doc.data()?['members'];
    return Group(
      name: doc.data()?['name'] ?? '',
      color: doc.data()?['color'],
      icon: doc.data()?['icon'],
      defaultCurrency: doc.data()?['defaultCurrency'],
      adminId: '',
      memberIds: [],
    );
  }
}
