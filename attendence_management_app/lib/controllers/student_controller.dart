import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> markAttendance(String name, String rollNo, String className, String status) async {
    if (uid == null) return;

    try {
      String todayDate = DateTime.now().toIso8601String().split('T').first;
      String docId = '$uid$todayDate';

      DocumentReference docRef = firebaseFirestore
          .collection('attendance')
          .doc(docId);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        showSnackBar(
          'Error',
          'Attendance already marked for today.',
          Icons.error,
          Colors.red,
        );
        return;
      }

      await docRef.set({
        'name': name,
        'rollNo': rollNo,
        'class': className,
        'status': status,
        'date': todayDate,
      });

      showSnackBar(
        'Success',
        'Attendance marked successfully!',
        Icons.check,
        Colors.green,
      );
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to mark attendance: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  Future<void> sendLeaveRequest(String name, String rollNo, String reason) async {
    if (uid == null) return;

    try {
      String requestDate = DateTime.now().toIso8601String().split('T').first;
      String requestId = '$uid$requestDate';

      DocumentReference requestRef = firebaseFirestore
          .collection('leaveRequests')
          .doc(requestId);

      await requestRef.set({
        'userId': uid,
        'name': name,
        'rollNo': rollNo,
        'reason': reason,
        'requestDate': requestDate,
        'status': 'Pending', // Admin will update this status
      });

      showSnackBar(
        'Success',
        'Leave request sent successfully!',
        Icons.check,
        Colors.green,
      );
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to send leave request: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  void showSnackBar(String title, String message, IconData icon, Color iconColor) {
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
