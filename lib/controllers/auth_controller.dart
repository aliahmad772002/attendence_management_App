import 'dart:io';
import 'dart:math';
import 'package:attendence_management_app/models/user_model.dart';
import 'package:attendence_management_app/view/admin/adminhome/admin_dashboard.dart';
import 'package:attendence_management_app/view/selectionScreen/selection_screen.dart';
import 'package:attendence_management_app/view/user/auth/login_screen.dart';
import 'package:attendence_management_app/view/user/userHome/user_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  var isLoading = false.obs;
  String? errorMessage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  Future<void> signUp(
      {File? image,
      required String name,
      required String email,
      required String password}) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (email.endsWith('@admin.com')) {
          await postAdminDataToDB(
            id: userCredential.user!.uid,
            name: name,
            email: email,
            password: password,
          );
          await prefs.setString('userType', 'admin');
          Get.to(() => LoginScreen());
          showSnackBar('Success', 'Admin signed up successfully!', Icons.check,
              Colors.green);
        } else if (email.endsWith('@gmail.com')) {
          await postUserDataToDB(
            id: userCredential.user!.uid,
            image: image,
            name: name,
            email: email,
            password: password,
          );
          await prefs.setString('userType', 'user');
          Get.to(() => LoginScreen());
          showSnackBar('Success', 'User signed up successfully!', Icons.check,
              Colors.green);
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar('Error', e.message!, Icons.close, Colors.red);
    } catch (e) {
      showSnackBar(
          'Error', 'An unexpected error occurred.', Icons.close, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postUserDataToDB({
    required String id,
    File? image,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      String orderCode = generateOrderCode();

      if (image != null) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('userprofile_images/$id.png');

        UploadTask uploadTask = storageReference.putFile(image);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();

          UserModel userModel = UserModel(
            name: name,
            email: email,
            password: password,
            uid: id,
            profilePicture: imageUrl,
            rollNo: orderCode,
          );
          await firebaseFirestore
              .collection('users')
              .doc(id)
              .set(userModel.toMap());
        });
      } else {
        UserModel userModel = UserModel(
          name: name,
          email: email,
          password: password,
          uid: id,
          profilePicture: "",
          rollNo: orderCode,
        );
        await firebaseFirestore
            .collection('users')
            .doc(id)
            .set(userModel.toMap());
      }
    } catch (e) {
      showSnackBar('Error', 'Failed to post data to Firestore.', Icons.close,
          Colors.red);
    }
  }

  Future<void> postAdminDataToDB({
    required String id,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await firebaseFirestore.collection('admin').doc(id).set({
        'name': name,
        'email': email,
        'password': password,
      });
      showSnackBar('Success', 'Admin signed up successfully!', Icons.check,
          Colors.green);
    } catch (e) {
      showSnackBar('Error', 'Failed to post data to Firestore.', Icons.close,
          Colors.red);
    }
  }

  String generateOrderCode() {
    var rng = Random();
    var code = StringBuffer();
    for (var i = 0; i < 5; i++) {
      code.write(rng.nextInt(10));
    }
    return code.toString();
  }

  Future<void> signin({required String email, required String password}) async {
    isLoading.value = true;
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (email.endsWith('@admin.com')) {
        await prefs.setString('userType', 'admin');
        Get.offAll(() => AdminDashboard());
      } else if (email.endsWith('@gmail.com')) {
        await prefs.setString('userType', 'user');
        Get.offAll(() => UserDashboard());
      }
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

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Get.to(const SelectionScreen());
  }

  Future<void> updateProfileImage({required File image}) async {
    try {
      isLoading.value = true;
      String userId = auth.currentUser!.uid;
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('userprofile_images/$userId.png');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        await firebaseFirestore.collection('users').doc(userId).update({
          'profilePicture': imageUrl,
        });
        showSnackBar(
          'Success',
          'Profile picture updated successfully!',
          Icons.check,
          Colors.green,
        );
      });
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to update profile picture: $e',
        Icons.close,
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
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
