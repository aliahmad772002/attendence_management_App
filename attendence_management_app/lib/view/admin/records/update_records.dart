import 'package:attendence_management_app/widgets/custom_bg.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/custom_input_field.dart';
import 'package:attendence_management_app/widgets/radio_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendence_management_app/controllers/student_controller.dart';

class UpdateAttendance extends StatefulWidget {
  const UpdateAttendance({super.key});

  @override
  State<UpdateAttendance> createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  final studentController = Get.put(StudentController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();

  DocumentSnapshot? attendanceRecord;
  String? selectedStatus;
  bool isChecking = false;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              CustomBg(
                imagePath: 'assets/images/stellar.png',
                text: 'Update Records',
                icon: Icons.arrow_back,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustomTextField(
                            inputType: TextInputType.name,
                            hintText: "Name",
                            controller: nameController,
                            validator: (String? value) {},
                          ),
                          SizedBox(height: height * 0.02),
                          CustomTextField(
                            inputType: TextInputType.number,
                            hintText: "Roll No",
                            controller: rollNoController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Roll No';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          if (isChecking) ...[
                            CircularProgressIndicator(),
                          ] else ...[
                            CustomButton(
                              text: 'Check',
                              onPressed: () async {
                                setState(() {
                                  isChecking = true;
                                });

                                DocumentSnapshot? record =
                                    await studentController
                                        .fetchAttendanceRecord(
                                  nameController.text,
                                  rollNoController.text,
                                );
                                if (record != null) {
                                  setState(() {
                                    attendanceRecord = record;
                                  });
                                }

                                setState(() {
                                  isChecking = false;
                                });
                              },
                            ),
                          ],
                          SizedBox(height: height * 0.02),
                          if (attendanceRecord != null) ...[
                            AttendanceRadioButton(
                              onChanged: (String? value) {
                                setState(() {
                                  selectedStatus = value;
                                });
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            if (isUpdating) ...[
                              CircularProgressIndicator(),
                            ] else ...[
                              CustomButton(
                                text: 'Update',
                                onPressed: () {
                                  if (selectedStatus != null &&
                                      attendanceRecord != null) {
                                    setState(() {
                                      isUpdating = true;
                                    });

                                    studentController
                                        .updateAttendanceStatus(
                                            attendanceRecord!, selectedStatus!)
                                        .then((_) {
                                      setState(() {
                                        isUpdating = false;
                                      });
                                    });
                                  }
                                },
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
