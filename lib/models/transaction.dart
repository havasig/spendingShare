import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_share/models/enums/split_by_type.dart';
import 'package:spending_share/models/enums/transaction_type.dart';

class Transaction {
  String? name;
  String databaseId;
  DocumentReference category;
  Timestamp date;
  String? exchangeRate;
  DocumentReference from;
  SplitByType splitByType;
  List<DocumentReference>? splitWeights;
  List<dynamic> to;
  TransactionType type;
  double value;
  String currency;

  Transaction({
    this.name,
    required this.databaseId,
    required this.category,
    required this.date,
    this.exchangeRate,
    required this.from,
    required this.splitByType,
    this.splitWeights,
    required this.to,
    required this.type,
    required this.value,
    required this.currency,
  });

  factory Transaction.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Transaction(
      name: doc.data()?['name'],
      databaseId: doc.id,
      to: doc.data()?['to'],
      splitWeights: [],
      splitByType: SplitByType.values.firstWhere((e) => e.toString() == doc.data()?['splitByType']),
      type: TransactionType.values.firstWhere((e) => e.toString() == doc.data()?['type']),
      category: doc.data()?['category'],
      from: doc.data()?['from'],
      date: doc.data()?['date'],
      value: double.parse(doc.data()!['value'].toString()),
      exchangeRate: doc.data()?['exchangeRate'],
      currency: doc.data()?['currency'],
    );
  }
}
