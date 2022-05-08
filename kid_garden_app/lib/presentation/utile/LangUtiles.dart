import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getText(String key) => language![key];
}

Map<String, dynamic>? language;

class ThugLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const ThugLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {

    return  ['en', 'ar'].contains(locale.languageCode);
  }


  @override
  Future<AppLocalizations> load(Locale locale) async {
    String string = await rootBundle.loadString("res/strings/${locale.languageCode}.json");
    language = json.decode(string);
    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }



  @override
  bool shouldReload(ThugLocalizationsDelegate old) => false;
}

