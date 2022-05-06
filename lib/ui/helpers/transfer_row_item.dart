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

class TransferRowItem extends StatelessWidget {
  const TransferRowItem({Key? key, required this.transfer, required this.groupData}) : super(key: key);

  final spending_share_transaction.Transaction transfer;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: transfer.from!.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var member = Member.fromDocument(snapshot.data!);
          return Row(
            children: [
              CircleIconButton(
                width: (MediaQuery.of(context).size.width - 197) / 8,
                //-padding*2 -iconWidth*4 -spacing*3
                color: groupData.color,
                icon: groupData.icon ?? member.icon ?? globals.icons['default'],
              ),
              Column(
                children: [
                  Text(transfer.name),
                  TextFormat.date(transfer.date.toDate()),
                  Text(member.name + ' ' + 'gave'.tr),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormat.roundedValueWithCurrencyAndColor(transfer.value, transfer.currency, groupData.color),
                  SizedBox(
                    height: h(30),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: transfer.to.first.get(),
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
