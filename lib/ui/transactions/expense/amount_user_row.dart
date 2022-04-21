import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';

import '../../../models/member.dart';
import '../../../utils/number_helper.dart';
import '../../../utils/screen_util_helper.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';

import 'package:spending_share/utils/globals.dart' as globals;

import '../../helpers/on_future_build_error.dart';

class AmountUserRow extends StatefulWidget {
  const AmountUserRow({Key? key, required this.memberReference, required this.color}) : super(key: key);

  final DocumentReference memberReference;
  final String color;

  @override
  State<AmountUserRow> createState() => _AmountUserRowState();
}

class _AmountUserRowState extends State<AmountUserRow> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
      textEditingController.text = formatNumberString(createTransactionChangeNotifier.to[widget.memberReference].toString());

      return FutureBuilder<DocumentSnapshot>(
        future: widget.memberReference.get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var member = Member.fromDocument(snapshot.data!);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIconButton(
                  onTap: () {},
                  color: createTransactionChangeNotifier.color!,
                  icon: member.icon ?? createTransactionChangeNotifier.groupIcon!,
                  width: 20,
                ),
                Text(member.name),
                GestureDetector(
                  onTap: () => createTransactionChangeNotifier.setSelectedMember(widget.memberReference),
                  child: Container(
                    padding: EdgeInsets.all(h(8)),
                    decoration: createTransactionChangeNotifier.selectedMember == widget.memberReference
                        ? BoxDecoration(
                            border: Border.all(color: globals.colors[createTransactionChangeNotifier.color]!, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      formatNumberString(createTransactionChangeNotifier.to[widget.memberReference].toString()) +
                          ' ' +
                          createTransactionChangeNotifier.currency,
                      style: TextStyleConstants.value(createTransactionChangeNotifier.color),
                    ),
                  ),
                ),
              ],
            );
          }
          return OnFutureBuildError(snapshot);
        },
      );
    });
  }

  Color getColor(Set<MaterialState> states) {
    return globals.colors[widget.color]!;
  }
}
