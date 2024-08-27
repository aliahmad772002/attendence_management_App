import 'package:attendence_management_app/controllers/report_controller.dart';
import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/widgets/custom_bg.dart';
import 'package:attendence_management_app/widgets/custom_button.dart';
import 'package:attendence_management_app/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final reportController = Get.put(ReportController());
  final TextEditingController rollNoController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              CustomBg(
                imagePath: 'assets/images/stellar.png',
                text: 'Report',
                icon: Icons.arrow_back,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null)
                                setState(() => fromDate = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: kTextColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                fromDate != null
                                    ? DateFormat('yyyy-MM-dd').format(fromDate!)
                                    : 'From Date',
                                style: const TextStyle(color: kTextColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null)
                                setState(() => toDate = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: kTextColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                toDate != null
                                    ? DateFormat('yyyy-MM-dd').format(toDate!)
                                    : 'To Date',
                                style: const TextStyle(color: kTextColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return reportController.isLoading.value
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: 'Generate Report',
                              onPressed: () {
                                if (rollNoController.text.isEmpty ||
                                    fromDate == null ||
                                    toDate == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please fill all fields.',
                                    icon: const Icon(Icons.error,
                                        color: Colors.red),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                reportController.generateReport(
                                  rollNo: rollNoController.text.trim(),
                                  fromDate: fromDate!,
                                  toDate: toDate!,
                                );
                              },
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
