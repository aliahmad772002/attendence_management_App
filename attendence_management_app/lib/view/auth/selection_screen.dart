import 'package:attendence_management_app/view/admin/admin_login.dart';
import 'package:attendence_management_app/view/student/student_dashboard.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Student',
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
              ),
              SizedBox(
                height: height*0.02,

              ),
              CustomButton(
                text: 'Admin',
                onPressed: () {
                  Get.to(() => AdminLogin());
                },
              ),
            ],
          ),),
    ));
  }
}
