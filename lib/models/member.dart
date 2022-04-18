import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String name;
  String? userFirebaseId;
  String? databaseId;
  String? icon;

  Member({
    required this.name,
    this.databaseId,
    this.userFirebaseId,
    this.icon,
  });

  factory Member.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Member(
      databaseId: doc.id, // TODO need?
      name: doc.data()?['name'],
      userFirebaseId: doc.data()?['userFirebaseId'],
      icon: doc.data()?['icon'],
    );
  }
}
