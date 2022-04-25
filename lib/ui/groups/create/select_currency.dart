import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import '../../../utils/config/environment.dart';

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
                  if(createChangeNotifier.defaultCurrency != null) getExchangeRate(createChangeNotifier.defaultCurrency!, newValue!, createChangeNotifier);
                  setState(() {
                    createChangeNotifier.setCurrency(newValue);
                    _dropdownValue = newValue!;
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

  @override
  void initState() {
    _dropdownValue = globals.currencies.keys.contains(widget.currency) ? widget.currency : 'USD';
    super.initState();
  }

  Future<void> getExchangeRate(String to, String from, CreateChangeNotifier createChangeNotifier) async {
    if (from == to) {
      createChangeNotifier.setExchangeRate(null);
      return;
    }
    double result = 0.0;
    try {
      String uri = '${Environment().config.currencyConverterbaseUrl}/currency/convert'
          '?api_key=${Environment().config.currencyConverterApiKey}'
          '&from=$from'
          '&to=$to'
          '&amount=1'
          '&format=json';
      var response = await http.get(Uri.parse(uri));
      Map<String, dynamic> map = json.decode(response.body);
      result = double.tryParse(map['rates'][to]['rate'])!;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    createChangeNotifier.setExchangeRate(result);
  }
}
