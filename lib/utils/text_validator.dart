import 'package:get/get.dart';

class TextValidator {
  static String? validateEmailText(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!)) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  static String? validateNameText(String? text) {
    return null; // TODO kell valamire validálni?
  }

  static String? validateGroupNameText(String? text) {
    //TODO kell ide barmi mas validacio?
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    return null;
  }

  static String? validateIsNotEmpty(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    return null;
  }

  static String? validateIsNotNegative(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (double.tryParse(text!)?.isNaN ?? true) return 'must_be_number'.tr;
    if (double.tryParse(text)! < 0) return 'must_be_zero_or_greater'.tr;
    return null;
  }
}
