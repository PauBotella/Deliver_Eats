import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xff1d2635);
  static const Color widgetColor = Color(0xff243042);
  static const Color inputBackground = Color(0xffB6DBF1);
  static const Color buttonColor = Color(0xfff0d6efd);

  static ThemeData theme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    scaffoldBackgroundColor: primary,

    //Input theme
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: inputBackground,
      filled: true,
      prefixStyle: TextStyle(
        color: Colors.red,
      ),
      labelStyle: TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      focusColor: widgetColor,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo),
          borderRadius: BorderRadius.circular(5)),
    ),
  );
}
