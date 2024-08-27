import 'package:attendence_management_app/controllers/report_controller.dart';
import 'package:attendence_management_app/widgets/custom_bg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants.dart';

class LeaveApproval extends StatefulWidget {
  const LeaveApproval({super.key});

  @override
  State<LeaveApproval> createState() => _LeaveApprovalState();
}

class _LeaveApprovalState extends State<LeaveApproval> {
  final leaveController = Get.put(ReportController());

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

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
                text: 'Leave Request',
                icon: Icons.arrow_back,
              ),
              Expanded(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('leaveRequests')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No leave requests found.'));
                      }

                      final leaveRequests = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: leaveRequests.length,
                        itemBuilder: (context, index) {
                          var request = leaveRequests[index];
                          var name = request['name'];
                          var rollNo = request['rollNo'];
                          var reason = request['reason'];
                          var requestDate = _formatDate(request['requestDate']);
                          var status = request['status'];
                          var requestId = request.id;

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              height: height * 0.25,
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
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: $name',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Roll No: $rollNo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      'Reason: $reason',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      'Date: $requestDate',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                trailing: status == 'Pending'
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.done,
                                                size: width * 0.07,
                                                color: kPrimaryColor),
                                            onPressed: () {
                                              leaveController
                                                  .approveLeaveRequest(
                                                      requestId);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close,
                                                size: width * 0.07, color: red),
                                            onPressed: () {
                                              leaveController
                                                  .rejectLeaveRequest(
                                                      requestId);
                                            },
                                          ),
                                        ],
                                      )
                                    : Text(
                                        status,
                                        style: TextStyle(
                                          fontSize: width * 0.05,
                                          color: status == 'Approved'
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
