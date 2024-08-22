import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromRGBO(46, 41, 78, 1);
const whiteColor = Color.fromRGBO(255, 255, 255, 1);
const lightGrey = Color.fromRGBO(240, 240, 240, 1);
const darkGrey = Color.fromRGBO(112, 112, 112, 1);
const fontGrey = Color.fromRGBO(73, 73, 73, 1);
const textfieldGrey = Color.fromRGBO(209, 209, 209, 1);


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
