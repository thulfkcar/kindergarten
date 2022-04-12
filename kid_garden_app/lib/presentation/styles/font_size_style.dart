import 'package:flutter/cupertino.dart';

class FontSizeStyle {
  static double mainFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.02;
  }

  static double titlePageFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.032;
  }
}
