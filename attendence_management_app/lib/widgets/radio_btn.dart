import 'package:flutter/material.dart';

class AttendanceRadioButton extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  AttendanceRadioButton({required this.onChanged});

  @override
  _AttendanceRadioButtonState createState() => _AttendanceRadioButtonState();
}

class _AttendanceRadioButtonState extends State<AttendanceRadioButton> {
  String? _attendance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Present'),
          leading: Radio<String>(
            value: 'Present',
            groupValue: _attendance,
            onChanged: (value) {
              setState(() {
                _attendance = value;
                widget.onChanged(_attendance); // Notify the parent widget of the change
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Absent'),
          leading: Radio<String>(
            value: 'Absent',
            groupValue: _attendance,
            onChanged: (value) {
              setState(() {
                _attendance = value;
                widget.onChanged(_attendance); // Notify the parent widget of the change
              });
            },
          ),
        ),
      ],
    );
  }
}
