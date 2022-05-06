import 'dart:math';

import 'package:spending_share/utils/globals.dart' as globals;

String formatNumberString(String value) {
  double doubleValue = double.parse(value);
  double rounded = ((doubleValue * pow(10, globals.decimals)).round() / pow(10, globals.decimals).toDouble());
  if (rounded.floor() == rounded) return rounded.toInt().toString();
  return rounded.toString();
}
