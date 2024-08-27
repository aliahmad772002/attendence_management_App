import 'package:attendence_management_app/controllers/student_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/widgets/custom_bg.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: height,
                  width: width,
                  child: Column(
                    children: [
                      CustomBg(
                        imagePath: 'assets/images/stellar.png',
                        text: 'Leave',
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
                                    Container(
                                      width: width * 0.85,
                                      height: height * 0.22,
                                      decoration: BoxDecoration(
                                        color: bgcolor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x3f000000),
                                            offset: Offset(0, 4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: reasonController,
                                        onChanged: (text) {
                                          int lines =
                                              '\n'.allMatches(text).length + 1;
                                          if (lines >= 4) {
                                            setState(() {
                                              Utils().toastMessage(
                                                  'Write your reason shortly!');
                                            });
                                          }
                                        },
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          enabledBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: 'Reason...',
                                          hintStyle: Theme.of(context)
                                              .inputDecorationTheme
                                              .hintStyle,
                                          focusedBorder: InputBorder.none,
                                          focusColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    CustomButton(
                                      text: 'Send',
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller.sendLeaveRequest(
                                            nameController.text.trim(),
                                            rollNoController.text.trim(),
                                            reasonController.text.trim(),
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
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
