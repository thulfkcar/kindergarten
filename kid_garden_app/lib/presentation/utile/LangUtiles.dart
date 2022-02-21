import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class StringResources {
  static StringResources? of(BuildContext context) {
    return Localizations.of<StringResources>(context, StringResources);
  }

  String getText(String key) => language![key];
}

Map<String, dynamic>? language;

class DemoLocalizationsDelegate extends LocalizationsDelegate<StringResources> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<StringResources> load(Locale locale) async {
    String string = await rootBundle.loadString("res/strings/${locale.languageCode}.json");
    language = json.decode(string);
    return SynchronousFuture<StringResources>(StringResources());
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}