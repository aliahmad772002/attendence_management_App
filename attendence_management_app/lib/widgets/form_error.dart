import 'package:attendence_management_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        children: List.generate(
            errors.length, (index) => formErrorText(error: errors[index]!)),
      ),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
       Icon(Icons.error_outline, color: kPrimaryColor, size: 20,),
        const SizedBox(
          width: 10,
        ),
        Text(error),
      ],
    );
  }
}
