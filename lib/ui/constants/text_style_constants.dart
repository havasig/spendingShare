import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'color_constants.dart';

class TextFormat {
  static Text date(DateTime date) {
    return Text(DateFormat('yyyy-MM-dd').format(date));
  }

  static Text roundedValueWithCurrencyAndColor(double value, String currency, MaterialColor? color) {
    if (value.floor() == value) {
      return Text(value.toInt().toString() + ' ' + currency, style: TextStyleConstants.value(color));
    } else {
      return Text(value.toString() + ' ' + currency, style: TextStyleConstants.value(color));
    }
  }
}

class TextStyleConstants {
  static TextStyle value(MaterialColor? color) {
    return TextStyle(
      color: color ?? ColorConstants.white.withOpacity(0.8),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static final h_1 = TextStyle(
    fontSize: 48,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final h_2 = TextStyle(
    fontSize: 32,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final h_3 = TextStyle(
    fontSize: 28,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final h_4 = TextStyle(
    fontSize: 24,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final h_5 = TextStyle(
    fontSize: 22,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final h_6 = TextStyle(
    fontSize: 20,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final body_1 = TextStyle(
    fontSize: 18,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final body_1_bold = TextStyle(
    fontSize: 18,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final body_2 = TextStyle(
    fontSize: 16,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final body_2_medium = TextStyle(
    fontSize: 16,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final body_3 = TextStyle(
    fontSize: 15,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static const sub_1 = TextStyle(
    fontSize: 14,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
  static final sub_1_light = TextStyle(
    fontSize: 14,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final sub_1_medium = TextStyle(
    fontSize: 14,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final sub_2 = TextStyle(
    fontSize: 13,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final sub_3 = TextStyle(
    fontSize: 12,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
  static final sub_4 = TextStyle(
    fontSize: 10,
    fontFamily: 'Nunito',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: ColorConstants.white.withOpacity(0.8),
  );
}
