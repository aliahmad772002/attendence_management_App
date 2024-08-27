import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/view/admin/adminauth/admin_login.dart';
import 'package:attendence_management_app/view/user/auth/login_screen.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Image.asset(
              'assets/images/logo.png',
              width: width * 0.4,
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Text(
              'WellCome to Stellar !',
              style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: red),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            CustomButton(
              text: 'Student',
              onPressed: () {
                Get.to(() => LoginScreen());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Admin',
              onPressed: () {
                Get.to(() => AdminLogin());
              },
            ),
          ],
        ),
      ),
    ));
  }
}
