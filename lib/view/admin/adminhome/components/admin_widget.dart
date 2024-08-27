import 'dart:io';
import 'package:attendence_management_app/controllers/auth_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminWidget extends StatelessWidget {
  AdminWidget({
    Key? key,
  }) : super(key: key);

  final picker = ImagePicker();
  final AuthController controller = Get.put(AuthController());

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      await controller.updateProfileImage(image: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.25,
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
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('admin')
                .doc(controller.auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String profileImage = userData['profilePicture'] ?? '';

                return Padding(
                  padding: EdgeInsets.only(left: width * 0.14),
                  child: ListTile(
                    leading:  CircleAvatar(

                      radius: width * 0.1,
                      backgroundImage:

                      AssetImage(

                        'assets/images/admin.png',
                      ),
                    ),
                    title: Text(
                      userData['name'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      userData['email'],
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
