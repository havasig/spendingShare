import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class SelectCurrency extends StatefulWidget {
  const SelectCurrency({Key? key, required this.currency, required this.color}) : super(key: key);

  final String currency;
  final String color;

  @override
  State<SelectCurrency> createState() => _SelectCurrencyState();
}

class _SelectCurrencyState extends State<SelectCurrency> {
  String _dropdownValue = 'USD';

  @override
  void initState() {
    _dropdownValue = globals.currencies.keys.contains(widget.currency) ? widget.currency : 'USD';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('selected_currency'.tr),
          Container(
            padding: EdgeInsets.symmetric(horizontal: h(6)),
            decoration: BoxDecoration(
              border: Border.all(color: globals.colors[widget.color]!),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Consumer<CreateChangeNotifier>(builder: (_, createChangeNotifier, __) {
              return DropdownButton<String>(
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
                    createChangeNotifier.setCurrency(newValue!);
                    _dropdownValue = newValue;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return globals.currencies.keys.map<Widget>((key) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(key),
                    );
                  }).toList();
                },
                items: globals.currencies.keys.map<DropdownMenuItem<String>>((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      key,
                      style: _dropdownValue == key ? TextStyle(color: globals.colors[widget.color]!) : null,
                    ),
                  );
                }).toList(),
              );
            }),
          )
        ],
      ),
    );
  }
}
