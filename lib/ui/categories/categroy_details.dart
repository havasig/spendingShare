import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/helpers/transaction_row_item.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/tab.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({Key? key, required this.firestore, required this.category, required this.color}) : super(key: key);

  final FirebaseFirestore firestore;
  final Category category;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SpendingShareAppBar(titleText: category.name),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabNavigation(color: color, tabs: [
            SpendingShareTab(
              'transactions'.tr,
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: category.transactions.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: category.transactions.elementAt(index).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                          return TransactionRowItem(
                            transaction,
                            color: color,
                            icon: category.icon,
                            firestore: firestore,
                          );
                        }
                        return OnFutureBuildError(snapshot);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: h(10)),
                ),
              ),
            ),
            SpendingShareTab(
              'statistics'.tr,
              Container(),
            ),
          ]),
        ));
  }
}
