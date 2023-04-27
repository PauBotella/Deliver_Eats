
class UserF {
  String email, username;
  String role,uid;

  UserF({required this.email, required this.username, required this.role,required this.uid});

  Map<String,dynamic> toMap() {

    return {
      'email': email,
      'username': username,
      'role_ID': role
    };

  }

  factory UserF.fromJson(Map<String,dynamic> json,String id) {

    return UserF(
        email: json['email'],
        username: json['username'],
        role: json['role_ID'],
      uid: id
    );
  }
}
