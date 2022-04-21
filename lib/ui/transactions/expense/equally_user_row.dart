import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';

import '../../../models/member.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';

import 'package:spending_share/utils/globals.dart' as globals;

import '../../helpers/on_future_build_error.dart';

class EquallyUserRow extends StatefulWidget {
  const EquallyUserRow({Key? key, required this.memberReference, required this.color}) : super(key: key);

  final DocumentReference memberReference;
  final String color;

  @override
  State<EquallyUserRow> createState() => _EquallyUserRowState();
}

class _EquallyUserRowState extends State<EquallyUserRow> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
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
                isChecked
                    ? Text(
                        (double.parse(createTransactionChangeNotifier.value!) / createTransactionChangeNotifier.to.length).toString() +
                            ' ' +
                            createTransactionChangeNotifier.currency,
                        style: TextStyleConstants.value(createTransactionChangeNotifier.color),
                      )
                    : Text(
                        '0 ' + createTransactionChangeNotifier.currency,
                        style: TextStyleConstants.value(createTransactionChangeNotifier.color),
                      ),
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    createTransactionChangeNotifier.allMembers;
                    createTransactionChangeNotifier.to;
                    setState(() {
                      isChecked = value!;
                      if (isChecked) {
                        createTransactionChangeNotifier.addTo(widget.memberReference);
                      } else {
                        createTransactionChangeNotifier.removeFromTo(widget.memberReference);
                      }
                    });
                  },
                )
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
