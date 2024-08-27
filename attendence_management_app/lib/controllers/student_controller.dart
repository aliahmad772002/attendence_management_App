import 'package:attendence_management_app/models/attendence_model.dart';
import 'package:attendence_management_app/models/leave_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  Future<void> markAttendance(
    String name,
    String rollNo,
    String status,
  ) async {
    if (uid == null) return;
    isLoading.value = true;
    try {
      bool isValid = await _validateUser(name, rollNo);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      if (!isValid) {
        showSnackBar(
            'Error', 'Invalid name or roll number.', Icons.error, Colors.red);
        return;
      }
      String todayDate = DateTime.now().toIso8601String().split('T').first;
      String docId = '$uid$todayDate';

      DocumentReference docRef =
          firebaseFirestore.collection('attendance').doc(docId);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        showSnackBar('Error', 'Attendance already marked for today.',
            Icons.error, Colors.red);
        return;
      }
      AttendenceModel attendenceModel = AttendenceModel(
        name: name,
        rollNo: rollNo,
        status: status,
        date: todayDate,
        uid: uid,
      );
      await docRef.set(attendenceModel.toMap());
      showSnackBar('Success', 'Attendance marked successfully!', Icons.check,
          Colors.green);
    } catch (e) {
      showSnackBar(
          'Error', 'Failed to mark attendance: $e', Icons.error, Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _validateUser(String name, String rollNo) async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('users')
          .where('name', isEqualTo: name)
          .where('rollNo', isEqualTo: rollNo)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      showSnackBar(
          'Error', 'Failed to validate student: $e', Icons.error, Colors.red);
      return false;
    }
  }

  Future<DocumentSnapshot?> fetchAttendanceRecord(
    String name,
    String rollNo,
  ) async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('attendance')
          .where('name', isEqualTo: name)
          .where('rollNo', isEqualTo: rollNo)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        showSnackBar(
            'Error', 'No student record found.', Icons.error, Colors.red);
        return null;
      }
    } catch (e) {
      showSnackBar('Error', 'Failed to fetch attendance record: $e',
          Icons.error, Colors.red);
      return null;
    }
  }

  Future<void> updateAttendanceStatus(
      DocumentSnapshot docSnapshot, String status) async {
    try {
      await docSnapshot.reference.update({'status': status});
      showSnackBar('Success', 'Attendance updated successfully!', Icons.check,
          Colors.green);
    } catch (e) {
      showSnackBar(
          'Error', 'Failed to update attendance: $e', Icons.error, Colors.red);
    }
  }

  Future<void> deleteAttendanceRecord(DocumentSnapshot docSnapshot) async {
    try {
      await docSnapshot.reference.delete();
      showSnackBar('Success', 'Attendance deleted successfully!', Icons.check,
          Colors.green);
    } catch (e) {
      showSnackBar(
          'Error', 'Failed to delete attendance: $e', Icons.error, Colors.red);
    }
  }

  Future<void> sendLeaveRequest(
      String name, String rollNo, String reason) async {
    if (uid == null) return;
    isLoading.value = true;

    try {
      bool isValid = await _validateUser(name, rollNo);
      if (!isValid) {
        showSnackBar(
            'Error', 'Invalid name or roll number.', Icons.error, Colors.red);
        return;
      }
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String requestDate = DateTime.now().toIso8601String().split('T').first;
      String requestId = '$uid$requestDate';
      DocumentReference requestRef =
          firebaseFirestore.collection('leaveRequests').doc(requestId);
      LeaveModel leaveModel = LeaveModel(
        name: name,
        rollNo: rollNo,
        reason: reason,
        requestDate: requestDate,
        status: 'Pending',
        uid: uid,
      );
      await requestRef.set(leaveModel.toMap());
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
