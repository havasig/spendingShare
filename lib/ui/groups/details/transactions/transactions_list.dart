import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/groups/details/transactions/transaction_list_page.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/helpers/transaction_row_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class TransactionsList extends StatelessWidget {
  const TransactionsList(this.transactions,
      {Key? key, required this.color, required this.icon, required this.firestore, required this.currency, required this.groupId})
      : super(key: key);

  final List<dynamic> transactions;
  final String color;
  final String icon;
  final String currency;
  final String groupId;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return Text('there_are_no_transactions'.tr);
    return Column(
      children: [
        Column(
          children: List.generate(
            transactions.length > 5 ? 5 : transactions.length,
            (index) => FutureBuilder<DocumentSnapshot>(
              future: transactions[index].get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                  return TransactionRowItem(
                    transaction,
                    color: color,
                    icon: icon,
                    firestore: firestore,
                  );
                }
                return OnFutureBuildError(snapshot);
              },
            ),
          ),
        ),
        Button(
          onPressed: () => Get.to(() => TransactionListPage(
                firestore: firestore,
                icon: icon,
                transactions: transactions,
                color: color,
                currency: currency,
                groupId: groupId,
              )),
          text: 'show_all_transactions'.tr,
          textColor: globals.colors[color]!,
          buttonColor: globals.colors[color]!.withOpacity(0.2),
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ],
    );
  }
}
