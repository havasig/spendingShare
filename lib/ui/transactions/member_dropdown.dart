import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class TransactionMemberDropdown extends StatefulWidget {
  const TransactionMemberDropdown({Key? key, required this.options, required this.color}) : super(key: key);

  final String color;
  final Map<String, dynamic> options;

  @override
  State<TransactionMemberDropdown> createState() => _TransactionMemberDropdownState();
}

class _TransactionMemberDropdownState extends State<TransactionMemberDropdown> {
  Map<String, dynamic> dropDownItems = {};
  String _dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropDownItems.addAll(widget.options);
    _dropdownValue = dropDownItems.keys.first;
  }

  String getTitle(CreateTransactionChangeNotifier createTransactionChangeNotifier) {
    return ('member'.tr + ' ' + (createTransactionChangeNotifier.type).name.toString().tr);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h(8)),
      child: Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
        createTransactionChangeNotifier.member == null
            ? createTransactionChangeNotifier.setMember(widget.options.entries.first.value)
            : null;
        return Row(
          children: [
            Text('member'.tr),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: h(6)),
              decoration: BoxDecoration(
                border: Border.all(color: globals.colors[widget.color]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: DropdownButton<String>(
                value: _dropdownValue,
                dropdownColor: ColorConstants.darkGray,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                elevation: 6,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: globals.colors[widget.color]!,
                ),
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    createTransactionChangeNotifier
                        .setMember(widget.options.entries.where((element) => element.key == newValue).first.value);
                    _dropdownValue = newValue!;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return dropDownItems.keys.map<Widget>((key) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(key),
                    );
                  }).toList();
                },
                items: dropDownItems.keys.map<DropdownMenuItem<String>>((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      key,
                      style: _dropdownValue == key ? TextStyle(color: globals.colors[widget.color]!) : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: h(10)),
            if (createTransactionChangeNotifier.type == TransactionType.expense) Text('paid'.tr),
            if (createTransactionChangeNotifier.type == TransactionType.transfer) Text('gave'.tr),
            if (createTransactionChangeNotifier.type == TransactionType.income) Text('got'.tr),
          ],
        );
      }),
    );
  }
}
