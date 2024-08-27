class UserModel {
  String uid;
  String name;
  String email;
  String profilePicture;
  String password;
  String rollNo;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.password,
    required this.rollNo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      password: map['password'],
      rollNo: map['rollNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'password': password,
      'rollNo': rollNo,
    };
  }
}
