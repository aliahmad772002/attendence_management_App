import 'package:attendence_management_app/controllers/admin_dashboard_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/view/admin/admin_signup.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/form_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final adminController = Get.put(AdminController());
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

                      controller: adminController.adminemailController,
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

                      controller: adminController.adminpasswordController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dont have an account?'),
                        SizedBox(width: width * 0.01),
                        InkWell(
                          onTap: () {
                            Get.to(() => AdminSignup());
                          },
                          child: Text('Signup',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Obx(() => CustomButton(
                      text: 'Login',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          adminController.signin();
                        }
                      },
                      isLoading: adminController.isLoading.value,
                    )),


                  ],
                ),
              )),
        ));
  }
}
