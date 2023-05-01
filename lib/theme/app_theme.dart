import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xff1d2635);
  static const Color widgetColor = Color(0xff243042);
  static const Color inputBackground = Color(0xffB6DBF1);
  static const Color buttonColor = Color(0xfff0d6efd);
  static const Color titleColor = Color(0xff93c47d);
  static const String euroTxt = '€';
  static const TextStyle titleStyle = TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: titleColor);
  static const TextStyle subtitleStyle = TextStyle(fontSize: 16,color: Colors.white);
  static const TextStyle ratingStyle = TextStyle(fontSize: 15,color: Colors.yellow);
  static const TextStyle priceStyle = TextStyle(color: Colors.red,fontWeight:FontWeight.bold);



  static ThemeData theme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(color: widgetColor, elevation: 0),
    scaffoldBackgroundColor: primary,

    //Input theme
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: inputBackground,
      filled: true,
      prefixStyle: const TextStyle(
        color: Colors.red,
      ),
      labelStyle: const TextStyle(
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
