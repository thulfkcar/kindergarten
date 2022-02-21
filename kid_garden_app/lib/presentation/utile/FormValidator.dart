import 'package:flutter/src/widgets/framework.dart';

import 'LangUtiles.dart';

class FormValidator {
  static FormValidator? _instance;

  BuildContext context;

  factory FormValidator(context) => _instance ??=  FormValidator._(context: context);

  FormValidator._({required this.context});

  String? validatePassword(String? value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp =  RegExp(patttern);
    if (value!.isEmpty) {
      return StringResources.of(context)?.getText("password_required") ?? "Error";
    } else if (value.length < 8) {
      return StringResources.of(context)?.getText("password_min") ?? "Error";
    } else if (!regExp.hasMatch(value)) {
      return StringResources.of(context)?.getText("password_form") ?? "Error";
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp =  RegExp(pattern);
    if (value!.isEmpty) {
      return StringResources.of(context)?.getText("email_required") ?? "Error";
    } else if (!regExp.hasMatch(value)) {
      return StringResources.of(context)?.getText("email_form") ?? "Error";
    } else {
      return null;
    }
  }
}