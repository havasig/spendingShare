import 'dart:collection';

import 'package:flutter/material.dart';

Map<String, IconData> icons = {
  'sport': Icons.directions_run,
  'politics': Icons.gavel,
  'science': Icons.wb_sunny,
  'wallet': Icons.account_balance_wallet,
  'add': Icons.add,
  'money': Icons.attach_money,
  'e': Icons.gavel,
  'r': Icons.wb_sunny,
  't': Icons.account_balance_wallet,
  'z': Icons.add,
  'sd': Icons.directions_run,
  'ds': Icons.gavel,
  'scasdddience': Icons.wb_sunny,
  'asd': Icons.account_balance_wallet,
  'adfdf': Icons.add,
  'dfgsw': Icons.directions_run,
  'fe': Icons.gavel,
  'rg': Icons.wb_sunny,
  'dt': Icons.account_balance_wallet,
  'zh': Icons.add,
  'sp1ort': Icons.directions_run,
  'po1litics': Icons.gavel,
  'sc1ience': Icons.wb_sunny,
  'wa1llet': Icons.account_balance_wallet,
  'ad1d': Icons.add,
  'w1': Icons.directions_run,
  '1e': Icons.gavel,
  '1r': Icons.wb_sunny,
  '1t': Icons.account_balance_wallet,
  'z1': Icons.add,
  's1d': Icons.directions_run,
  'd1s': Icons.gavel,
  'sc1asdddience': Icons.wb_sunny,
  'as1d': Icons.account_balance_wallet,
  'ad1fdf': Icons.add,
  'd1fgsw': Icons.directions_run,
  'f1e': Icons.gavel,
  'r1g': Icons.wb_sunny,
  'd1t': Icons.account_balance_wallet,
  '1zh': Icons.add,
};

Map<String, MaterialColor> colors = {
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'green': Colors.green,
  'lightBlue': Colors.lightBlue,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'blueGrey': Colors.blueGrey,
};

const int circleShade = 500;
const int iconShade = 100;

SplayTreeMap<String, dynamic> currencies = SplayTreeMap.from({"EUR": "Euro", "HUF": "Hungarian forint", "USD": "United States dollar"});
