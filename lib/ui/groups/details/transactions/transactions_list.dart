import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/helpers/transaction_row_item.dart';
import 'package:spending_share/ui/transactions/transaction_list_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList(this.transactions, {Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final List<dynamic> transactions;
  final GroupData groupData;
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
                  return Padding(
                    padding: EdgeInsets.only(bottom: h(8)),
                    child: TransactionRowItem(
                      transaction,
                      groupData: groupData,
                      firestore: firestore,
                    ),
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
                transactions: transactions,
                groupData: groupData,
              )),
          text: 'show_all_transactions'.tr,
          textColor: groupData.color,
          buttonColor: groupData.color.withOpacity(0.2),
          width: MediaQuery.of(context).size.width * 09,
        ),
      ],
    );
  }
}
