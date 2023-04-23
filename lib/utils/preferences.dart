import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  static late SharedPreferences _prefs;
  static String _email = '';
  static String _password = '';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get email {
    return _prefs.getString('email') ?? _email;
  }

  static String get password {
    return _prefs.getString('password') ?? _password;
  }
  static set email (String email) {
    _email = email;
    _prefs.setString('email', email);
  }
  static set password (String password) {
    _password = password;
    _prefs.setString('password', password);
  }
}