
class UserF {
  String email, username;
  String role;

  UserF({required this.email, required this.username, required this.role});

  Map<String,dynamic> toMap() {

    return {
      'email': email,
      'username': username,
      'role_ID': role
    };

  }

  factory UserF.fromJson(Map<String,dynamic> json) {

    return UserF(
        email: json['email'],
        username: json['username'],
        role: json['role_ID'],
    );
  }
}
