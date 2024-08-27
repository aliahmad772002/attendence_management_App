import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ThemeData(
      scaffoldBackgroundColor: bgcolor,
      fontFamily: "Muli",
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          )),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: kTextColor,
            fontSize: width * 0.05,
            fontFamily: "Muli",
            fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            color: kTextColor, fontSize: width * 0.04, fontFamily: "Muli"),
        bodySmall: TextStyle(
            color: kTextColor, fontSize: width * 0.03, fontFamily: "Muli"),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: kTextColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  borderSide: BorderSide(color: kTextColor),
  gapPadding: 10,
);
