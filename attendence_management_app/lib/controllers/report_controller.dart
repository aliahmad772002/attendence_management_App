import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReportController extends GetxController {
  static ReportController get instance => Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  Future<void> approveLeaveRequest(String requestId) async {
    try {
      DocumentReference requestRef =
          firebaseFirestore.collection('leaveRequests').doc(requestId);
      await requestRef.update({'status': 'Approved'});
      showSnackBar(
        'Success',
        'Leave request approved!',
        Icons.check,
        Colors.green,
      );
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to approve leave request: $e',
        Icons.error,
        Colors.red,
      );
    }
  }

  Future<void> rejectLeaveRequest(String requestId) async {
    try {
      DocumentReference requestRef =
          firebaseFirestore.collection('leaveRequests').doc(requestId);
      await requestRef.update({'status': 'Rejected'});
      showSnackBar(
        'Success',
        'Leave request rejected!',
        Icons.check,
        Colors.green,
      );
    } catch (e) {
      showSnackBar(
        'Error',
        'Failed to reject leave request: $e',
        Icons.error,
        Colors.red,
      );
    }
  }
  Future<void> generateReport({
    required String rollNo,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    isLoading.value = true;
    try {

      QuerySnapshot attendanceSnapshot = await firebaseFirestore
          .collection('attendance')
          .where('rollNo', isEqualTo: rollNo)
          .get();
      List<DocumentSnapshot> filteredAttendance =
          attendanceSnapshot.docs.where((doc) {
        DateTime docDate = DateTime.parse(doc['date']);
        return docDate.isAfter(fromDate) && docDate.isBefore(toDate) ||
            docDate.isAtSameMomentAs(fromDate) ||
            docDate.isAtSameMomentAs(toDate);
      }).toList();
      QuerySnapshot leaveSnapshot = await firebaseFirestore
          .collection('leaveRequests')
          .where('rollNo', isEqualTo: rollNo)
          .get();
      List<DocumentSnapshot> filteredLeaveRequests =
          leaveSnapshot.docs.where((doc) {
        DateTime requestDate = DateTime.parse(doc['requestDate']);
        return requestDate.isAfter(fromDate) && requestDate.isBefore(toDate) ||
            requestDate.isAtSameMomentAs(fromDate) ||
            requestDate.isAtSameMomentAs(toDate);
      }).toList();
      int totalDays = filteredAttendance.length;
      int presents =
          filteredAttendance.where((doc) => doc['status'] == 'Present').length;
      int absents =
          filteredAttendance.where((doc) => doc['status'] == 'Absent').length;
      int leavesApproved = filteredLeaveRequests
          .where((doc) => doc['status'] == 'Approved')
          .length;
      int leavesRejected = filteredLeaveRequests
          .where((doc) => doc['status'] == 'Rejected')
          .length;
      int leaves = leavesApproved + leavesRejected;
      String grade = _calculateGrade(presents);
      Get.defaultDialog(
        title: 'Attendance Report',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Roll No: $rollNo'),
            Text('Total Days: $totalDays'),
            Text('Presents: $presents'),
            Text('Leaves Approved: $leavesApproved'),
            Text('Leaves Rejected: $leavesRejected'),
            Text('Total Leaves: $leaves'),
            Text('Absents: $absents'),
            Text('Grade: $grade'),
          ],
        ),
        confirm: CustomButton(text: "Close", onPressed: Get.back),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate report: $e',
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _calculateGrade(int presents) {
    if (presents >= 26) return 'A';
    if (presents >= 20) return 'B';
    if (presents >= 15) return 'C';
    if (presents >= 10) return 'D';
    return 'F';
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
