import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/debt.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';

import 'debt_item.dart';

class DebtsList extends StatelessWidget {
  const DebtsList(this.debts, {Key? key, required this.currency, required this.color, required this.icon}) : super(key: key);

  final List<dynamic> debts;
  final String currency;
  final MaterialColor color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (debts.isEmpty) return Text('there_are_no_debts'.tr);
    return Column(
      children: debts
          .map<Widget>(
            (debts) => FutureBuilder<DocumentSnapshot>(
              future: debts.get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var debt = Debt.fromDocument(snapshot.data!);
                  return DebtItem(
                      onTap: () {}, from: debt.from, to: debt.to, value: debt.value, currency: currency, color: color, icon: icon);
                }
                return OnFutureBuildError(snapshot);
              },
            ),
          )
          .toList(),
    );
  }
}
