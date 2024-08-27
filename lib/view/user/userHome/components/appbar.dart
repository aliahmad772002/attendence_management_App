import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData iconData;
  CustomAppBar({required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final controller = Get.put(AuthController());
    return AppBar(
      leading: Container(),
      backgroundColor: kPrimaryColor,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: whiteColor),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.signOut();
          },
          icon: Icon(
            iconData,
            color: whiteColor,
            size: width * 0.05,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
