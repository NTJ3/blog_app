// import 'package:baseproject/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String token = "token";

class SharedPreferenceHelper {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token);
  }

  static Future<bool> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(token, value);
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
