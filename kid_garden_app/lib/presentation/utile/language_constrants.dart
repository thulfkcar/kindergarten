import 'package:flutter/material.dart';

import 'LangUtiles.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalizations.of(context)?.getText(key)?? key;
}