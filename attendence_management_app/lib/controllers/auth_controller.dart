import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:attendence_management_app/models/user_model.dart';
import 'package:attendence_management_app/view/admin/admin_dashboard.dart';
import 'package:attendence_management_app/view/auth/login_screen.dart';
import 'package:attendence_management_app/view/auth/selection_screen.dart';
import 'package:attendence_management_app/view/student/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  var isLoading = false.obs;
  String? errorMessage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  String? get uid => FirebaseAuth.instance.currentUser?.uid; // Getter for UID

  Future<void> signUp({File? image}) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
         postdatatoDB(
          id: userCredential.user!.uid,
          image: image,
        );
        Get.to(() => LoginScreen());
        showSnackBar('Success', 'Now please login!', Icons.check, Colors.green);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar('Error', e.message!, Icons.close, Colors.red);
    } catch (e) {
      showSnackBar('Error', 'An unexpected error occurred.', Icons.close, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }



  void postdatatoDB({
    required String id,
    File? image,

  }) async {
    try {
      String orderCode = generateOrderCode();
      // Check if an image is selected
      if (image != null) {
        // Upload image to Firebase Storage
        Reference storageReference =
        FirebaseStorage.instance.ref().child('userprofile_images/$id.png');

        UploadTask uploadTask = storageReference.putFile(image);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          // Save user data with image URL to Firestore
          UserModel userModel = UserModel(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            uid: id,
            profilePicture: imageUrl,
            rollNo: orderCode,
          );

          // Add new user to 'users' collection
          await firebaseFirestore
              .collection('users')
              .doc(id)
              .set(userModel.toMap());
          showSnackBar(
            'Success',
            'Signup successfully!',
            Icons.check,
            Colors.green,
          );
        });
      } else {
        // Save user data without image to Firestore
        UserModel userModel = UserModel(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          uid: id,
          profilePicture: "",
          rollNo: orderCode,
        );

        await firebaseFirestore
            .collection('users')
            .doc(id)
            .set(userModel.toMap());
        showSnackBar(
          'Success',
          'Signup successfully!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      // log('Failed to post data to Firestore: $e');  // Add a log message
      showSnackBar(
        'Error',
        'Failed to post data to Firestore.',
        Icons.close,
        Colors.red,
      );
    }
  }



  String generateOrderCode() {
    var rng = Random();
    var code = StringBuffer();
    for (var i = 0; i < 5; i++) { // Loop 5 times for a 5-digit code
      code.write(rng.nextInt(10)); // Generate a random digit and add to the code
    }
    return code.toString();
  }


  String? _userEmail;




  Future<void> signin() async {
    isLoading.value = true;
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user!;
      Get.offAll(() => StudentDashboard());
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        'Error',
        e.code == 'user-not-found'
            ? 'No user found for that email.'
            : 'Wrong password provided.',
        Icons.close,
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateUserProfile({File? image}) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;

        // Check if an image is selected
        if (image != null) {
          // Upload image to Firebase Storage
          Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$uid.png');

          UploadTask uploadTask = storageReference.putFile(image);

          // Wait for the image upload task to complete
          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();

            // Update seller image in Firestore
            await firebaseFirestore
                .collection('users')
                .doc(uid)
                .update({'userImage': imageUrl});
          });
        }

        // Update seller name in Firestore
        await firebaseFirestore
            .collection('users')
            .doc(uid)
            .update({'userName': nameController.text});

        showSnackBar(
          'Success',
          'Seller data updated!',
          Icons.check,
          Colors.green,
        );
      }
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to update Seller data: $e',
        Icons.close,
        Colors.red,
      );
    }
  }


  void signOut() async {
    await FirebaseAuth.instance.signOut();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isLoggedIn', false);
    Get.to(const SelectionScreen());
  }

  // Future<UserModel> getUserInfo() async {
  //   try {
  //     String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  //     DocumentSnapshot userDoc =
  //     await firebaseFirestore.collection('users').doc(uid).get();
  //
  //     if (userDoc.exists) {
  //       // Explicitly cast the data to Map<String, dynamic>
  //       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
  //       return UserModel.fromMap(userData);
  //     } else {
  //       // Handle the case where user information is not found
  //       return UserModel(); // You might want to handle this better
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     print(e.toString());
  //     return UserModel(); // You might want to handle this better
  //   }
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(
      String title, String message, IconData icon, Color iconColor) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }
}

class StaticData {
  static String uid = '';

}
