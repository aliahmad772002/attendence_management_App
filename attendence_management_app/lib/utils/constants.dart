import 'package:flutter/material.dart';

const bgcolor = Color(0xffF8F2E9);
const kPrimaryColor = Color(0xff524593);
const whiteColor = Color(0xffFCF9F6);
const darkGrey = Color.fromRGBO(112, 112, 112, 1);
const kTextColor = Colors.black;
const red = Colors.red;

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kalreadyAccountError = "Email Already Used ";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
