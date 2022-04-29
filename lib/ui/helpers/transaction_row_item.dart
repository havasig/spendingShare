import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/expense_row_item.dart';
import 'package:spending_share/ui/helpers/income_row_item.dart';
import 'package:spending_share/ui/helpers/transfer_row_item.dart';
import 'package:spending_share/ui/transactions/expense/expense_details.dart';

class TransactionRowItem extends StatelessWidget {
  const TransactionRowItem(this.transaction, {Key? key, required this.firestore, required this.color, this.icon}) : super(key: key);

  final spending_share_transaction.Transaction transaction;
  final IconData? icon;
  final MaterialColor color;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return content(transaction);
  }

  Widget content(spending_share_transaction.Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.expense:
        return GestureDetector(
            onTap: () => Get.to(() => ExpenseDetails(firestore: firestore, expense: transaction, color: color)),
            child: ExpenseRowItem(expense: transaction, color: color, icon: icon));
      case TransactionType.transfer:
        return TransferRowItem();
      case TransactionType.income:
        return IncomeRowItem();
    }
  }
}
