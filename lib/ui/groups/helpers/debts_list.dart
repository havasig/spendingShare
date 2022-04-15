import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/utils/loading_indicator.dart';

import 'on_future_build_error.dart';

class DebtsList extends StatelessWidget {
  const DebtsList(this.transactions, {Key? key}) : super(key: key);

  final List<dynamic> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions
          .map<Widget>(
            (category) => FutureBuilder<DocumentSnapshot>(
              future: category.get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                  return Text(transaction.databaseId);
                }
                return OnFutureBuildError(snapshot);
              },
            ),
          )
          .toList(),
    );
  }
}
