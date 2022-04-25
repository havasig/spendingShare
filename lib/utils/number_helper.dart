import 'dart:math';

import 'package:spending_share/utils/globals.dart' as globals;

String formatNumberString(String value) {
  double doubleValue = double.parse(value);
  if (doubleValue.floor() == doubleValue) return doubleValue.toInt().toString();
  return ((doubleValue * pow(10, globals.decimals)).round() / pow(10, globals.decimals).toDouble()).toString();
}
