import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/models/transaction_type.dart';
import 'package:spending_share/ui/groups/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(this.transaction, {Key? key, required this.color, required this.icon}) : super(key: key);

  final spending_share_transaction.Transaction transaction;
  final String color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: transaction.from.get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var member = Member.fromDocument(snapshot.data!);
              return Row(
                children: [
                  CircleIconButton(
                    onTap: () {},
                    width: 20,
                    color: color,
                    icon: member.icon ?? icon,
                  ),
                  Column(
                    children: [
                      Text(transaction.name ?? (transaction.type.toString()[0].toUpperCase() + transaction.type.toString().substring(1))),
                      Text(transaction.date.toDate().toString()),
                      Text(nameByTransactionType(transaction.type, member.name)),
                    ],
                  )
                ],
              );
            }
            return OnFutureBuildError(snapshot);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (transaction.value.floor() == transaction.value)
              Text(transaction.value.toInt().toString() + ' ' + transaction.currency)
            else
              Text(transaction.value.toString() + ' ' + transaction.currency),
            SizedBox(
              height: h(30),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: transaction.to.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: transaction.to[index].get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var member = Member.fromDocument(snapshot.data!);
                          return CircleIconButton(
                            onTap: () {},
                            width: 7,
                            color: color,
                            icon: member.icon ?? icon,
                          );
                        }
                        return OnFutureBuildError(snapshot);
                      },
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }

  String nameByTransactionType(TransactionType type, String memberName) {
    // TODO: ezt itt nyelvektől függőnek kell megcsinálni lol
    switch (type) {
      case TransactionType.expense:
        // TODO: Handle this case.
        break;
      case TransactionType.transfer:
        // TODO: Handle this case.
        break;
      case TransactionType.income:
        // TODO: Handle this case.
        break;
    }
    return memberName;
  }
}
