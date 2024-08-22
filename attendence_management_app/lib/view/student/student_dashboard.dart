import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/view/student/mark_attendance.dart';
import 'package:attendence_management_app/view/student/mark_leave.dart';
import 'package:attendence_management_app/view/student/view_details.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  SafeArea(child: Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Signout',
              onPressed: () {
              controller.signOut();
              },
            ),
            CustomButton(
              text: 'Attendence',
              onPressed: () {
                Get.to(() => MarkAttendence());
              },
            ),
            SizedBox(
              height: height*0.02,

            ),
            CustomButton(
              text: 'Leave',
              onPressed: () {
                Get.to(() => MarkLeave());
              },
            ),
            SizedBox(
              height: height*0.02,

            ),
            CustomButton(
              text: 'Details',
              onPressed: () {
                Get.to(() => ViewDetails());
              },
            ),

          ],
        ),),
    ));
  }
}
