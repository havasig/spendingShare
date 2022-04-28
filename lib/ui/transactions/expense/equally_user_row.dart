import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';

import '../../../models/member.dart';
import '../../../utils/number_helper.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';
import '../../helpers/on_future_build_error.dart';

class EquallyUserRow extends StatefulWidget {
  const EquallyUserRow({Key? key, required this.memberReference, required this.color}) : super(key: key);

  final DocumentReference memberReference;
  final MaterialColor color;

  @override
  State<EquallyUserRow> createState() => _EquallyUserRowState();
}

class _EquallyUserRowState extends State<EquallyUserRow> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: widget.memberReference.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var member = Member.fromDocument(snapshot.data!);
          return Consumer<CreateTransactionChangeNotifier>(
            builder: (_, createTransactionChangeNotifier, __) => Consumer<CreateTransactionData>(builder: (_, createTransactionData, __) {
              bool isChecked =
                  createTransactionChangeNotifier.to.entries.firstWhere((element) => element.key == widget.memberReference).value.item1 !=
                      '0';
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    color: widget.color,
                    icon: member.icon ?? createTransactionData.groupIcon,
                    width: 20,
                  ),
                  Text(member.name),
                  Text(
                    formatNumberString(createTransactionChangeNotifier.to[widget.memberReference]!.item1.toString()) +
                        ' ' +
                        createTransactionChangeNotifier.currency,
                    style: TextStyleConstants.value(widget.color),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                        if (isChecked) {
                          createTransactionChangeNotifier.recalculateToEqualAdd(widget.memberReference);
                        } else {
                          createTransactionChangeNotifier.recalculateToEqualRemove(widget.memberReference);
                        }
                      });
                    },
                  )
                ],
              );
            }),
          );
        }
        return OnFutureBuildError(snapshot);
      },
    );
  }

  Color getColor(Set<MaterialState> states) {
    return widget.color;
  }
}
