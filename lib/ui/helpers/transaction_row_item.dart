import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/expense_row_item.dart';
import 'package:spending_share/ui/helpers/income_row_item.dart';
import 'package:spending_share/ui/helpers/transfer_row_item.dart';
import 'package:spending_share/ui/transactions/expense/expense_details_first_page.dart';
import 'package:spending_share/ui/transactions/income/income_details.dart';
import 'package:spending_share/ui/transactions/transfer/transfer_details.dart';

class TransactionRowItem extends StatelessWidget {
  const TransactionRowItem(this.transaction, {Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final spending_share_transaction.Transaction transaction;
  final GroupData groupData;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return content(transaction, context);
  }

  Widget content(spending_share_transaction.Transaction transaction, BuildContext context) {
    switch (transaction.type) {
      case TransactionType.expense:
        return GestureDetector(
            onTap: () async {
              Category category = Category.fromDocument(await transaction.category!.get());
              Member member = Member.fromDocument(await transaction.from!.get());
              Get.to(() => ExpenseDetailsFirstPage(
                    firestore: firestore,
                    groupData: groupData,
                    category: category,
                    member: member,
                    expense: transaction,
                  ));

              /*var group = await firestore.collection('groups').doc(groupData.groupId).get();
              List<DocumentReference> members = List<DocumentReference>.from(group['members']);
              members.removeWhere((element) => transaction.to.contains(element));
              transaction.to.addAll(members);
              transaction.toWeights?.addAll(List.generate(members.length, (index) => '0'));
              transaction.toAmounts?.addAll(List.generate(members.length, (index) => '0'));
              Get.to(() => ExpenseDetails(
                    firestore: firestore,
                    expense: transaction,
                    groupData: groupData,
                  ));*/
            },
            child: ExpenseRowItem(expense: transaction, groupData: groupData));
      case TransactionType.transfer:
        return GestureDetector(
            onTap: () => Get.to(() => TransferDetails(firestore: firestore, transfer: transaction, groupData: groupData)),
            child: TransferRowItem(
              transfer: transaction,
              groupData: groupData,
            ));
      case TransactionType.income:
        return GestureDetector(
            onTap: () => Get.to(() => IncomeDetails(firestore: firestore, expense: transaction, groupData: groupData)),
            child: IncomeRowItem(income: transaction, groupData: groupData));
    }
  }
}
