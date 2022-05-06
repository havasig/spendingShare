import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:tuple/tuple.dart';

import '../../../models/member.dart';
import '../../../utils/number_helper.dart';
import '../../../utils/screen_util_helper.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';
import '../../helpers/on_future_build_error.dart';

class AmountUserRow extends StatefulWidget {
  const AmountUserRow({Key? key, required this.memberReference, required this.groupData}) : super(key: key);

  final DocumentReference memberReference;
  final GroupData groupData;

  @override
  State<AmountUserRow> createState() => _AmountUserRowState();
}

class _AmountUserRowState extends State<AmountUserRow> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: widget.memberReference.get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var member = Member.fromDocument(snapshot.data!);
          return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
            if (createTransactionChangeNotifier.to[widget.memberReference] == null) {
              createTransactionChangeNotifier.to[widget.memberReference] = const Tuple2('0', '0');
            }
            textEditingController.text = formatNumberString(createTransactionChangeNotifier.to[widget.memberReference]!.item1.toString());
            return GestureDetector(
              onTap: () => createTransactionChangeNotifier.setSelectedMember(widget.memberReference),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    color: widget.groupData.color,
                    icon: member.icon ?? widget.groupData.icon,
                    width: 20,
                  ),
                  Text(member.name),
                  Container(
                    padding: EdgeInsets.all(h(8)),
                    decoration: createTransactionChangeNotifier.selectedMember == widget.memberReference
                        ? BoxDecoration(
                            border: Border.all(color: widget.groupData.color, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      formatNumberString(createTransactionChangeNotifier.to[widget.memberReference]!.item1.toString()) +
                          ' ' +
                          createTransactionChangeNotifier.currency,
                      style: TextStyleConstants.value(widget.groupData.color),
                    ),
                  ),
                ],
              ),
            );
          });
        }
        return OnFutureBuildError(snapshot);
      },
    );
  }

  Color getColor(Set<MaterialState> states) {
    return widget.groupData.color;
  }
}
