import 'package:blog_app/core/index.dart';

class Validator {
  //Email Validator
  static bool isValidEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static bool isValidPassword(String password) => password.length > 3;

  static String? validateEmail(String? val) {
    if (val!.trim().isEmpty) {
      return Strings.message.kEnterEmail;
    } else if (!Validator.isValidEmail(val)) {
      return Strings.message.kEnterValidEmail;
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    if (val!.trim().isEmpty) {
      return Strings.message.kEnterPassword;
    } else if (!Validator.isValidPassword(val)) {
      return Strings.message.kEnterValidPassword;
    } else {
      return null;
    }
  }

  static String? validateUserName(String? val) {
    if (val!.trim().isEmpty) {
      return Strings.message.kEnterName;
    } else {
      return null;
    }
  }

  static String? validateEmptyString(String? val, String msg) {
    if (val!.trim().isEmpty) {
      return msg;
    } else {
      return null;
    }
  }
}
