import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  // static String userLoggedInKey = '';
  static String userNameKey = '';
  static String userEmailKey = '';

  // static Future<bool> setUserLoggedInStatus(bool isUserLoggedIn) async {
  //   final sf = await SharedPreferences.getInstance();

  //   return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  // }

  static Future<bool> setUserName(String userName) async {
    final sf = await SharedPreferences.getInstance();

    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> setUserEmail(String email) async {
    final sf = await SharedPreferences.getInstance();

    return await sf.setString(userEmailKey, email);
  }

  // static Future<bool?> getUserLoggedInStatus() async {
  //   final sf = await SharedPreferences.getInstance();

  //   return sf.getBool(userLoggedInKey);
  // }

  static Future<String?> getUserName() async {
    final sf = await SharedPreferences.getInstance();

    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final sf = await SharedPreferences.getInstance();

    return sf.getString(userEmailKey);
  }
}
