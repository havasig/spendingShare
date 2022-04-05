import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String name;
  String? userFirebaseId;
  String databaseId;

  Member({
    this.name = '',
    this.userFirebaseId = '',
    this.databaseId = '',
  });

  factory Member.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Member(
      databaseId: doc.id,
      name: doc.data()?['name'] ?? '',
      userFirebaseId: doc.data()?['userFirebaseId'],
    );
  }
}
