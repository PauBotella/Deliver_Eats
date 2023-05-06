import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  static late SharedPreferences _prefs;
  static String _email = '';
  static String _password = '';
  static bool _isUserCreated = false;
  static String _googleMap = '';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get email {
    return _prefs.getString('email') ?? _email;
  }

  static bool get isUserCreated {
    return _prefs.getBool('isUserCreated') ?? _isUserCreated;
  }

  static String get googleMap {
    return _prefs.getString('googleMap') ?? _googleMap;
  }

  static String get password {
    return _prefs.getString('password') ?? _password;
  }
  static set email (String email) {
    _email = email;
    _prefs.setString('email', email);
  }

  static set googleMap (String googleMap) {
    _googleMap = googleMap;
    _prefs.setString('googleMap', googleMap);
  }

  static set isUserCreated (bool userCreated){
    _isUserCreated = userCreated;
    _prefs.setBool('isUserCreated', userCreated);
  }

  static set password (String password) {
    _password = password;
    _prefs.setString('isUserCreated', password);
  }

}