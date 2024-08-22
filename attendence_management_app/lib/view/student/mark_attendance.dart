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
  final TextEditingController classController = TextEditingController();
  String? _attendance;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                hintText: "Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                controller: nameController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                hintText: "Roll No",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Roll No';
                  }
                  return null;
                },
                controller: rollNoController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                hintText: "Class",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Class';
                  }
                  return null;
                },
                controller: classController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              AttendanceRadioButton(
                onChanged: (value) {
                  setState(() {
                    _attendance = value;
                  });
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomButton(
                text: 'Save',
                onPressed: () {
                  if (_attendance != null) {
                    studentcontroller.markAttendance(
                      nameController.text,
                      rollNoController.text,
                      classController.text,
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
    );
  }
}

