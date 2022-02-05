
import 'package:flutter/material.dart';

class KidThem {


  KidThem._();

  static final Color _iconColor = Colors.blueAccent.shade200;
  static const Color _lightPrimaryColor = Color(0xFF546E7A);
  static const Color _lightPrimaryVariantColor = Color(0xFF546E7A);
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const maleForeground=Color(0xff668fff);
  static const maleBackGround=Color(0x66668fff);
  static const dialogBackground=Color(0xff2e2b3f);
  static const dialogBorderAndText=Color(0xffe5e5e5);
  static const profileDark=Color(0xff221f2e);
  static const contentText=Color(0xff798289);
  static const mainThemColor=Color(0xff7366ff);
  static const secondaryColorOfSaveButton=Color(0xffff6cab);
  static const shadow=Color(0x667366ff);
  static const specSelectedSecondaryColor=Color(0x00212b35);
  static const darkButton=Color(0x52727cbe);

  static const Color _darkPrimaryColor = Color(0xff7366ff);
  static const Color imageBakGround = Color(0x657366ff);
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static const   textTitleColor=Colors.black;

  static const Gradient gradientSave =  LinearGradient(colors: [Color(0xff7366ff), Color(0xffff6cab)] );

  static final ThemeData lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color:_darkSecondaryColor,fontFamily: "Roboto",fontWeight: FontWeight.bold,fontSize: 26 ),
        color: _lightPrimaryVariantColor,
        iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        primaryVariant: _lightPrimaryVariantColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor,
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
        color: _darkPrimaryVariantColor,
        iconTheme: IconThemeData(color: _darkOnPrimaryColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        primaryVariant: _darkPrimaryVariantColor,
        secondary: _darkSecondaryColor,
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
  _lightScreenHeading1TextStyle.copyWith(color: _darkOnPrimaryColor);

}