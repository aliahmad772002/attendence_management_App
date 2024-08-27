import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final VoidCallback? togglePasswordVisibility;

  CustomTextField({
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.inputType,
    this.obscureText = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          border: Theme.of(context).inputDecorationTheme.border,
          contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          suffixIcon: togglePasswordVisibility != null
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              size: 20,
            ),
            onPressed: togglePasswordVisibility,
          )
              : null,
        ),
        controller: controller,
        style: Theme.of(context).inputDecorationTheme.hintStyle,
        validator: validator,
      ),
    );
  }
}
class Utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
