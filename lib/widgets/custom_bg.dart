import 'package:attendence_management_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomBg extends StatelessWidget {
  final String imagePath;
  final String text;
  final icon;
  CustomBg({required this.imagePath, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.3,
      width: width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      icon,
                      color: whiteColor,
                    )),
              ],
            ),
          ),
          Image.asset(
            imagePath,
            width: width * 0.27,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: width * 0.08,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
