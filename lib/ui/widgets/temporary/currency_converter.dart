import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      title: "Currency Converter",
      home: CurrencyConverter(),
    ));

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String?> currencies = [];
  String fromCurrency = "EUR";
  String toCurrency = "HUF";
  String result = '';
  String currencyConverterApiKey = "33027ce7013f5ba479e63fe09ca189ba3d9f50c2";
  String baseUrl = "https://api.getgeoapi.com/v2";

  // Currency converter: https://currency.getgeoapi.com/documentation/

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://openexchangerates.org/api/currencies.json";
    var response = await http.get(Uri.parse(uri), headers: {"Accept": "application/json"});
    Map<String, dynamic> curMap = json.decode(response.body);
    currencies = curMap.keys.toList();
    setState(() {});
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    String uri = '$baseUrl/currency/convert?api_key=$currencyConverterApiKey&from=$fromCurrency&to=$toCurrency&amount=10&format=json';
    var response = await http.get(Uri.parse(uri));
    Map<String, dynamic> responseBody = json.decode(response.body);
    setState(() {
      var b = (double.parse(fromTextController.text) * double.parse(responseBody['rates'][toCurrency]['rate'])).toString();
      result = b;
    });
    print(result);
    return "Success";
  }

  /* Example response
  {
  "base_currency_code": "EUR",
  "base_currency_name": "Euro",
  "amount": "10.0000",
  "updated_date": "2022-04-08",
  "rates": {
    "HUF": {
      "currency_name": "Hungarian forint",
      "rate": "377.1721",
      "rate_for_amount": "3771.7212"
    }
  },
  "status": "success"
}
*/

  _onFromChanged(String? value) {
    setState(() {
      fromCurrency = value ?? '';
    });
  }

  _onToChanged(String? value) {
    setState(() {
      toCurrency = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
      ),
      body: currencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          style: const TextStyle(fontSize: 20.0, color: Colors.black),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: _doConversion,
                      ),
                      ListTile(
                        title: Chip(
                          label: result != ''
                              ? Text(
                                  result,
                                )
                              : const Text(""),
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String? value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value ?? 'null'),
                  ],
                ),
              ))
          .toList(),
      onChanged: (String? value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value);
        } else {
          _onToChanged(value);
        }
      },
    );
  }
}
