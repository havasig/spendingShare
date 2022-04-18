import 'package:cloud_firestore/cloud_firestore.dart';

class Debt {
  String databaseId;
  DocumentReference from;
  DocumentReference to;
  double value;

  Debt({
    required this.databaseId,
    required this.from,
    required this.to,
    required this.value,
  });

  factory Debt.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Debt(
      databaseId: doc.id,
      from: doc.data()?['from'],
      to: doc.data()?['to'],
      value: double.parse(doc.data()!['value'].toString()),
    );
  }
}
