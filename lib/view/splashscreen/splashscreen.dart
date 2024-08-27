import 'dart:async';
import 'package:attendence_management_app/view/admin/adminhome/admin_dashboard.dart';
import 'package:attendence_management_app/view/user/userHome/user_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../selectionScreen/selection_screen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString('userType');

    Future.delayed(const Duration(seconds: 4), () {
      if (userType == 'admin') {
        Get.offAll(() => AdminDashboard());
      } else if (userType == 'user') {
        Get.offAll(() => UserDashboard());
      } else {
        Get.to(() => const SelectionScreen(),
            transition: Transition.rightToLeft);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0f0c29),
              Color(0xff302b63),
              Color(0xff24243e),
            ],
          ),
        ),
        child: Image.asset(
          'assets/images/stellar.png',
        ),
      ),
    ));
  }
}
