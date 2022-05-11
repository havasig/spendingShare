import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/fab/create_transaction_fab.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/helpers/transaction_row_item.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({
    Key? key,
    required this.firestore,
    required this.groupData,
    this.transactionsDocumentReference,
    this.spendingShareTransactions,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;
  final List<dynamic>? transactionsDocumentReference;
  final List<spending_share_transaction.Transaction>? spendingShareTransactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(
        titleText: 'transactions'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              transactionsDocumentReference != null
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: transactionsDocumentReference!.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: transactionsDocumentReference![index].get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                              return TransactionRowItem(
                                transaction,
                                groupData: groupData,
                                firestore: firestore,
                              );
                            }
                            return OnFutureBuildError(snapshot);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: h(10)),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: spendingShareTransactions!.length,
                      itemBuilder: (context, index) {
                        return TransactionRowItem(
                          spendingShareTransactions![index],
                          groupData: groupData,
                          firestore: firestore,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: h(10)),
                    ),
              SizedBox(height: h(65)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        firestore: firestore,
        selectedIndex: 1,
        color: groupData.color,
      ),
      floatingActionButton: CreateTransactionFab(
        firestore: firestore,
        groupData: groupData,
      ),
    );
  }
}
