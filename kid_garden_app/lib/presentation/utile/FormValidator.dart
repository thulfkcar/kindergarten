import 'package:flutter/src/widgets/framework.dart';
import 'package:tuple/tuple.dart';

import 'LangUtiles.dart';

class FormValidator {
  static FormValidator? _instance;

  BuildContext context;

  factory FormValidator(context) => _instance ??=  FormValidator._(context: context);

  FormValidator._({required this.context});

  String? validatePassword(String? value) {
    String patttern = r'[0-9][0-9][0-9][@]';
    // String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp =  RegExp(patttern);
    if (value!.isEmpty) {
      return "password is required";
    } else if (value.length < 3) {
      return "password mus be ar least 3 character";
    } else if (!regExp.hasMatch(value)) {
      return "invalid format ";
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp =  RegExp(pattern);
    if (value!.isEmpty) {
      return "email is required";
    } else if (!regExp.hasMatch(value)) {
      return "email format is invalid";
    } else {
      return null;
    }
  }



  String? validatePhone(String? value) {
    String pattern =
        r'7[3-9][0-9]{8}';
    RegExp regExp =  RegExp(pattern);
    if (value!.isEmpty) {
      return AppLocalizations.of(context)?.getText("phone_required")?? "phone number is required";
    } else if (!regExp.hasMatch(value)) {
      return "invalid phone number";
    } else {
      return null;
    }
  }
  String? validateNotEmpty(String? value) {
    String pattern =
        r'/^$|\s+/';
    RegExp regExp =  RegExp(pattern);
    if (value!.isEmpty) {
      return "filed required.!!";
    }  else {
      return null;
    }
  }
}