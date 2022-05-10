
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KidThem {


  KidThem._();
  static Color third = const Color(0xffFFEAA2);
  static Color female1 = const Color(0xffE78989);
  static Color female2 = const Color(0xffFEB2B4);
  static Color female3 = const Color(0xffFEDCDC);
  static Color male1 = const Color(0xff89C7E7);
  static Color male2 = const Color(0xffADD8E5);
  static Color male3 = const Color(0xffC4EBF1);
  static Color text1 = const Color(0xff3A515E);
  static Color text2 = const Color(0xff8298A5);
  static Color text3 = const Color(0xffB3BEC2);
  static Color text4 = const Color(0xffdfdfdf);
  static Color text5 = const Color(0xffe5e5e5);
  static Color text6 = const Color(0xfff1f1f1);
  static Color error = const Color(0xffC92929);
  static Color active = const Color(0xff32BE23);
  static Color white = const Color(0xffffffff);

  static final Color _iconColor = Colors.blueAccent.shade200;


  static const Color _lightPrimaryColor = Color(0xffFCD639);
  static const Color _lightPrimaryVariantColor = Color(0xffe5e5e5);
  static const Color _lightSecondaryColor = Color(0xffFCE16D);
  static const Color _lightOnSecondaryColor = Color(0xff3A515E);
  static const Color _lightOnPrimaryColor = Colors.black;


  static const Color _darkPrimaryColor = Color(0xffFCD639);
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Color(0xffFCE16D);
  static const Color _darkOnSecondaryColor = Color(0xff3A515E);
  static const Color _darkOnPrimaryColor = Colors.white;

  static const   textTitleColor=Colors.black;

  static const Gradient gradientSave =  LinearGradient(colors: [Color(0xff7366ff), Color(0xffff6cab)] );

  static final ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue, //
          statusBarBrightness: Brightness.light// or set color with: Color(0xFF0000FF)
        ),
        titleTextStyle: TextStyle(color:_darkSecondaryColor,fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 26 ),
        color: _lightPrimaryVariantColor,
        iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        primaryContainer: _lightPrimaryVariantColor,
        secondary: _lightSecondaryColor,
        onSecondary: _lightOnSecondaryColor,
        onPrimary: _lightOnPrimaryColor,
        background: Colors.white70,

      ),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _lightTextTheme,
      dividerTheme: const DividerThemeData(
          color: Colors.black12
      )

  );

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: _darkPrimaryVariantColor,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.blue, //
            statusBarBrightness: Brightness.dark// or set color with: Color(0xFF0000FF)
        ),
        color: _darkPrimaryVariantColor,
        iconTheme: IconThemeData(color: _darkOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        primaryContainer: _darkPrimaryVariantColor,
        secondary: _darkSecondaryColor,
        onSecondary: _darkOnSecondaryColor,
        onPrimary: _darkOnPrimaryColor,
        background: Colors.white12,
      ),
      iconTheme: IconThemeData(
        color: _iconColor,
      ),
      textTheme: _darkTextTheme,
      dividerTheme: const DividerThemeData(
          color: Colors.black
      )  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline1: _lightScreenHeading1TextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline1: _darkScreenHeading1TextStyle,
  );

  static final TextStyle _lightScreenHeading1TextStyle =
  TextStyle(fontSize: 26.0,fontWeight:FontWeight.bold, color: _lightOnPrimaryColor,fontFamily: "Roboto");

  static final TextStyle _darkScreenHeading1TextStyle =
  _lightScreenHeading1TextStyle.copyWith(color: _darkOnPrimaryColor,);

}