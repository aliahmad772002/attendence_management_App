import 'package:attendence_management_app/view/admin/admin_dashboard.dart';
import 'package:attendence_management_app/view/admin/admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var adminnameController = TextEditingController();
  var adminemailController = TextEditingController();
  var adminpasswordController = TextEditingController();


  var isLoading = false.obs;
  String? errorMessage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  String? get uid => FirebaseAuth.instance.currentUser?.uid; // Getter for UID

  Future<void> signUp() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: adminemailController.text,
        password: adminpasswordController.text,
      );

      if (userCredential.user != null) {
        postdatatoDB(
          id: userCredential.user!.uid,

        );
        Get.to(() => AdminLogin());
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


  }) async {
    try {





          // Add new user to 'users' collection
          await firebaseFirestore
              .collection('Admin')
              .doc(id)
              .set({

            "Adminname": adminnameController.text,
            "Adminemail": adminemailController.text,
            "Adminpassword": adminpasswordController.text,
            "uid": id,
          });
          showSnackBar(
            'Success',
            'Signup successfully!',
            Icons.check,
            Colors.green,
          );

      }
 catch (e) {
      // log('Failed to post data to Firestore: $e');  // Add a log message
      showSnackBar(
        'Error',
        'Failed to post data to Firestore.',
        Icons.close,
        Colors.red,
      );
    }
  }





  String? _userEmail;




  Future<void> signin() async {
    isLoading.value = true;
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: adminemailController.text,
        password: adminpasswordController.text,
      ))
          .user!;
      Get.offAll(() => AdminDashboard());
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
