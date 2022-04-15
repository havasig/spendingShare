import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String databaseId;
  String category;
  String date;
  String? exchangeRate;
  String from;
  String splitBy;
  List<String>? splitWeights = [];
  List<String> to = [];
  String type;
  double value;

  Transaction({
    required this.databaseId,
    required this.category,
    required this.date,
    this.exchangeRate,
    required this.from,
    required this.splitBy,
    this.splitWeights,
    required this.to,
    required this.type,
    required this.value,
  });

  factory Transaction.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Transaction(
      databaseId: doc.id,
      to: [],
      type: '',
      splitBy: '',
      category: '',
      from: '',
      date: '',
      value: 0,
    );
  }
}
