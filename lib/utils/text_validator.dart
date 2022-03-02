import 'package:get/get.dart';
class TextValidator {
  static String? validatePassText(String text) {
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 6) {
      return 'Too short';
    }
  }
  static String? validateCompareText(String text, text2) {
    if (text != text2) {
      return 'The two passwords are not the same';
    }
  }
  static String? validateVerificationCodeText(String text) {
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if(!text.isNumericOnly){
      return 'The code consists of digits only';
    }
    if (text.length != 6) {
      return 'Must be 6 digits';
    }
  }
  static String? validateEmptyText(String text) {
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
  }
  static String? validateEmailText(String text) {
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text)) {
      return 'Email is invalid';
    }
  }
}

// TODO localization