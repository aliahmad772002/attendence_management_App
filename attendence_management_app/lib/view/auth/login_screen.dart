import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/view/auth/registration_screen.dart';
import 'package:attendence_management_app/view/student/student_dashboard.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/custom_input_field.dart';
import 'package:attendence_management_app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              height: height,
              width: width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(

                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: fontGrey),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kEmailNullError);
                          return "";
                        } else if (!emailValidatorRegExp.hasMatch(value)) {
                          addError(error: kInvalidEmailError);
                          return "";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(

                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: fontGrey),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kPassNullError);
                          return "";
                        } else if (value.length < 6) {
                          addError(error: kShortPassError);
                          return "";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    FormError(errors: errors),
                    SizedBox(height: height * 0.02),
                    Obx(() => CustomButton(
                      text: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          controller.signin();
                        }
                      },
                      isLoading: controller.isLoading.value,
                    )),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        SizedBox(width: width * 0.02),
                        InkWell(
                          onTap: () {
                            Get.to(() => SignupScreeen());
                          },
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}
