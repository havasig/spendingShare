import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spending_share/models/enums/transaction_type.dart';

class Transaction {
  String databaseId;
  DocumentReference? category;
  DocumentReference createdBy;
  String currency;
  Timestamp date;
  String? exchangeRate;
  String name;
  DocumentReference from;
  List<dynamic> to;
  List<dynamic> toAmounts;
  List<dynamic> toWeights;
  TransactionType type;
  double value;

  Transaction({
    required this.databaseId,
    this.category,
    required this.createdBy,
    required this.currency,
    required this.date,
    this.exchangeRate,
    required this.name,
    required this.from,
    required this.to,
    required this.toAmounts,
    required this.toWeights,
    required this.type,
    required this.value,
  });

  factory Transaction.fromDocument(DocumentSnapshot doc) {
    doc as DocumentSnapshot<Map<String, dynamic>>;
    return Transaction(
      databaseId: doc.id,
      category: doc.data()?['category'],
      createdBy: doc.data()?['createdBy'],
      currency: doc.data()?['currency'],
      date: doc.data()?['date'],
      exchangeRate: doc.data()?['exchangeRate'],
      from: doc.data()?['from'],
      name: doc.data()?['name'],
      to: doc.data()?['to'],
      toAmounts: doc.data()?['toAmounts'],
      toWeights: doc.data()?['toWeights'],
      type: TransactionType.values.firstWhere((e) => e.toString() == doc.data()?['type']),
      value: doc.data()!['value'],
    );
  }
}
