import 'package:flutter/material.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/expense_row_item.dart';
import 'package:spending_share/ui/helpers/income_row_item.dart';
import 'package:spending_share/ui/helpers/transfer_row_item.dart';

class TransactionRowItem extends StatelessWidget {
  const TransactionRowItem(this.transaction, {Key? key, required this.color, this.icon}) : super(key: key);

  final spending_share_transaction.Transaction transaction;
  final String? icon;
  final String color;

  @override
  Widget build(BuildContext context) {
    return content(transaction);
  }

  Widget content(spending_share_transaction.Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.expense:
        return ExpenseRowItem(expense: transaction, color: color, icon: icon);
      case TransactionType.transfer:
        return TransferRowItem();
      case TransactionType.income:
        return IncomeRowItem();
    }
  }
}
