import 'package:get/get.dart';

class TextValidator {
  static String? validateEmailText(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!)) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  static String? validatePasswordText(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (text!.length < 8) {
      return 'password_is_too_short'.tr;
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
}
