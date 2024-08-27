import 'package:attendence_management_app/view/admin/adminhome/components/admin_widget.dart';
import 'package:attendence_management_app/view/admin/report/report_screen.dart';
import 'package:attendence_management_app/view/admin/records/records.dart';
import 'package:attendence_management_app/view/user/userHome/components/appbar.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../adminLeave/leave_approval.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Dashboard',
        iconData: Icons.logout,
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            AdminWidget(),
            SizedBox(
              height: height * 0.04,
            ),
            CustomButton(
              text: 'Records',
              onPressed: () {
                Get.to(() => RecordsScreen());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Leave Approve',
              onPressed: () {
                Get.to(() => LeaveApproval());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomButton(
              text: 'Report',
              onPressed: () {
                Get.to(
                  () => ReportScreen(),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
