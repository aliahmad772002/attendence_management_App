import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/view/user/attendence/mark_attendance.dart';
import 'package:attendence_management_app/view/user/details/view_details.dart';
import 'package:attendence_management_app/view/user/leave/mark_leave.dart';
import 'package:attendence_management_app/view/user/userHome/components/appbar.dart';
import 'package:attendence_management_app/view/user/userHome/components/home_widget.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'User Dashboard',
        iconData: Icons.logout,
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            HomeWidget(),
            SizedBox(
              height: height * 0.04,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Attendence',
              onPressed: () {
                Get.to(() => MarkAttendence());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Leave',
              onPressed: () {
                Get.to(() => MarkLeave());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Details',
              onPressed: () {
                Get.to(() => ViewDetails());
              },
            ),
          ],
        ),
      ),
    ));
  }
}
