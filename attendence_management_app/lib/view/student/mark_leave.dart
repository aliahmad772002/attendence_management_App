import 'package:attendence_management_app/controllers/student_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkLeave extends StatefulWidget {
  const MarkLeave({super.key});

  @override
  State<MarkLeave> createState() => _MarkLeaveState();
}

class _MarkLeaveState extends State<MarkLeave> {
  final StudentController controller = Get.put(StudentController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

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
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: width * 0.85,
                  height: height * 0.22,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(248, 238, 238, 238),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: lightGrey,
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: reasonController,
                          onChanged: (text) {
                            int lines = '\n'.allMatches(text).length + 1;
                            if (lines >= 4) {
                              setState(() {
                                Utils().toastMessage(
                                    'Write your reason shortly!');
                              });
                            }
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Reason...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              CustomButton(
                text: 'Send',
                onPressed: () {
                  // Call the sendLeaveRequest function from StudentController
                  controller.sendLeaveRequest(
                    nameController.text.trim(),
                    rollNoController.text.trim(),
                    reasonController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
