class LeaveModel {
  String uid;
  String name;
  String rollNo;
  String status;
  String reason;
  String requestDate;

  LeaveModel({
    required this.uid,
    required this.name,
    required this.status,
    required this.reason,
    required this.requestDate,
    required this.rollNo,
  });

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      uid: map['uid'],
      name: map['name'],
      status: map['status'],
      reason: map['reason'],
      requestDate: map['requestDate'],
      rollNo: map['rollNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'status': status,
      'reason': reason,
      'requestDate': requestDate,
      'rollNo': rollNo,
    };
  }
}
