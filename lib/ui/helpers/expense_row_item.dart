import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'on_future_build_error.dart';

class ExpenseRowItem extends StatelessWidget {
  const ExpenseRowItem({Key? key, required this.expense, required this.color, this.icon}) : super(key: key);

  final spending_share_transaction.Transaction expense;
  final MaterialColor color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: expense.from!.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var member = Member.fromDocument(snapshot.data!);
          return Row(
            children: [
              CircleIconButton(
                width: (MediaQuery.of(context).size.width - 197) / 8,
                //-padding*2 -iconWidth*4 -spacing*3
                color: color,
                icon: icon ?? member.icon ?? globals.icons['default'],
              ),
              Column(
                children: [
                  Text(expense.name),
                  Text(expense.date.toDate().toString()),
                  FutureBuilder<DocumentSnapshot>(
                    future: expense.category?.get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var category = Category.fromDocument(snapshot.data!);
                        return Text(category.name);
                      }
                      return OnFutureBuildError(snapshot);
                    },
                  ),
                  Text(member.name + ' ' + 'paid_for'.tr),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (expense.value.floor() == expense.value)
                    Text(expense.value.toInt().toString() + ' ' + expense.currency, style: TextStyleConstants.value(color))
                  else
                    Text(expense.value.toString() + ' ' + expense.currency, style: TextStyleConstants.value(color)),
                  SizedBox(
                    height: h(30),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: expense.to.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: expense.to[index].get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              var member = Member.fromDocument(snapshot.data!);
                              return CircleIconButton(
                                width: 7,
                                color: color,
                                icon: member.icon ?? icon,
                              );
                            }
                            return OnFutureBuildError(snapshot);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: h(2)),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return OnFutureBuildError(snapshot);
      },
    );
  }
}
