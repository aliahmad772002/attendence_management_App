import 'dart:convert';

class AttendenceModel {
  String name;
  String rollNo;
  String status;
  String date;
  String uid;

  AttendenceModel({
    required this.name,
    required this.rollNo,
    required this.status,
    required this.date,
    required this.uid,
  });

  AttendenceModel copyWith({
    String? name,
    String? rollNo,
    String? status,
    String? date,
    String? uid,
  }) {
    return AttendenceModel(
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      status: status ?? this.status,
      date: date ?? this.date,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'rollNo': rollNo,
      'status': status,
      'date': date,
      'uid': uid,
    };
  }

  factory AttendenceModel.fromMap(Map<String, dynamic> map) {
    return AttendenceModel(
      name: map['name'] as String,
      rollNo: map['rollNo'] as String,
      status: map['status'] as String,
      date: map['date'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendenceModel.fromJson(String source) =>
      AttendenceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendenceModel(name: $name, rollNo: $rollNo, status: $status, date: $date, uid: $uid)';
  }

  @override
  bool operator ==(covariant AttendenceModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.rollNo == rollNo &&
        other.status == status &&
        other.date == date &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        rollNo.hashCode ^
        status.hashCode ^
        date.hashCode ^
        uid.hashCode;
  }
}
