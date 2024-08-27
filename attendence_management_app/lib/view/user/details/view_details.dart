import 'package:attendence_management_app/utils/constants.dart';
import 'package:attendence_management_app/widgets/custom_bg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({Key? key}) : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
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
                text: 'Details',
                icon: Icons.arrow_back,
              ),
              Expanded(
                child: SizedBox(
                  height: height,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('attendance')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text('No attendance records found.'));
                      }

                      final attendanceRecords = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: attendanceRecords.length,
                        itemBuilder: (context, index) {
                          var record = attendanceRecords[index];
                          var formattedDate = _formatDate(record['date']);
                          var status = record['status'];
                          var rollNo = record['rollNo'];

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
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
                                title: Text(
                                  'Date: $formattedDate',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  'Attendance Status: $status',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: Text(
                                  'Roll No: $rollNo',
                                  style: Theme.of(context).textTheme.bodySmall,
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
