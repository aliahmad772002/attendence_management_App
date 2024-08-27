import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/view/user/auth/registration_screen.dart';
import 'package:attendence_management_app/widgets/custom_bg.dart';
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
  bool isPasswordVisible = false;
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void togglePasswordVisibility() {
    // Add this method
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
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
          child: Column(
            children: [
              CustomBg(
                imagePath: 'assets/images/stellar.png',
                text: 'Sign In',
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                            inputType: TextInputType.emailAddress,
                            hintText: "Email",
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(error: kEmailNullError);
                                return "";
                              } else if (!emailValidatorRegExp
                                  .hasMatch(value)) {
                                addError(error: kInvalidEmailError);
                                return "";
                              }
                              return null;
                            },
                            controller: emailController),
                        SizedBox(height: height * 0.02),
                        CustomTextField(
                            inputType: TextInputType.visiblePassword,
                            hintText: "Password",
                            obscureText: !isPasswordVisible, // Add this line
                            togglePasswordVisibility:
                                togglePasswordVisibility, // Add this line
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
                            controller: passwordController),
                        SizedBox(height: height * 0.02),
                        FormError(errors: errors),
                        SizedBox(height: height * 0.02),
                        Obx(() => CustomButton(
                              text: 'Login',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.signin(
                                      email: emailController.text,
                                      password: passwordController.text);
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
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
