import 'package:get/get.dart';

class TextValidator {
  static String? validateEmailText(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text!)) {
      return 'invalid_email'.tr;
    }
  }

  static String? validatePasswordText(String? text) {
    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
    if (text!.length < 8) {
      return 'password_is_too_short'.tr;
    }
  }

  static String? validateNameText(String? text) {
    return 'TODO';
  }
}
