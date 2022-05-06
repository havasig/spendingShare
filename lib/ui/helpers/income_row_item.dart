import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'on_future_build_error.dart';

class IncomeRowItem extends StatelessWidget {
  const IncomeRowItem({Key? key, required this.income, required this.groupData}) : super(key: key);

  final spending_share_transaction.Transaction income;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(
          width: (MediaQuery.of(context).size.width - 197) / 8,
          color: groupData.color,
          icon: groupData.icon ?? globals.icons['default'],
        ),
        Column(
          children: [
            Text(income.name),
            TextFormat.date(income.date.toDate()),
            if (income.incomeFrom != null && income.incomeFrom!.isNotEmpty) Text('income_from'.tr + income.incomeFrom!),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormat.roundedValueWithCurrencyAndColor(income.value, income.currency, groupData.color),
            SizedBox(
              height: h(30),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: income.to.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: income.to[index].get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var member = Member.fromDocument(snapshot.data!);
                        return CircleIconButton(
                          width: 7,
                          color: groupData.color,
                          icon: member.icon ?? groupData.icon,
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
}
