import 'package:attendence_management_app/widgets/custom_bg.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/custom_input_field.dart';
import 'package:attendence_management_app/widgets/radio_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendence_management_app/controllers/student_controller.dart';

class MarkAttendence extends StatefulWidget {
  const MarkAttendence({super.key});

  @override
  State<MarkAttendence> createState() => _MarkAttendenceState();
}

class _MarkAttendenceState extends State<MarkAttendence> {
  final studentcontroller = Get.put(StudentController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _attendance;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return studentcontroller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: height,
                  width: width,
                  child: Column(
                    children: [
                      CustomBg(
                        imagePath: 'assets/images/stellar.png',
                        text: 'Attendance',
                        icon: Icons.arrow_back,
                      ),
                      SizedBox(height: height * 0.02),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: height,
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      inputType: TextInputType.name,
                                      hintText: "Name",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Name';
                                        }
                                        return null;
                                      },
                                      controller: nameController,
                                    ),
                                    SizedBox(height: height * 0.02),
                                    CustomTextField(
                                      inputType: TextInputType.number,
                                      hintText: "Roll No",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Roll No';
                                        }
                                        return null;
                                      },
                                      controller: rollNoController,
                                    ),
                                    SizedBox(height: height * 0.02),
                                    AttendanceRadioButton(
                                      onChanged: (value) {
                                        setState(() {
                                          _attendance = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: height * 0.02),
                                    CustomButton(
                                      text: 'Save',
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            _attendance != null) {
                                          studentcontroller.markAttendance(
                                            nameController.text,
                                            rollNoController.text,
                                            _attendance!,
                                          );
                                        } else {
                                          studentcontroller.showSnackBar(
                                            'Error',
                                            'Please select attendance status.',
                                            Icons.error,
                                            Colors.red,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
