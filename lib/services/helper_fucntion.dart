import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  // static String userLoggedInKey = '';
  static String userFirstNameKey = '';
  static String userLastNameKey = '';
  static String userEmailKey = '';

  // static Future<bool> setUserLoggedInStatus(bool isUserLoggedIn) async {
  //   final sf = await SharedPreferences.getInstance();

  //   return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  // }

  static Future<bool> setUserFirstName(String userFirstName) async {
    final sf = await SharedPreferences.getInstance();

    return await sf.setString(userFirstNameKey, userFirstName);
  }

  static Future<bool> setUserLastName(String userLastName) async {
    final sf = await SharedPreferences.getInstance();

    return await sf.setString(userLastNameKey, userLastName);
  }

  static Future<bool> setUserEmail(String email) async {
    final sf = await SharedPreferences.getInstance();

    return await sf.setString(userEmailKey, email);
  }

  // static Future<bool?> getUserLoggedInStatus() async {
  //   final sf = await SharedPreferences.getInstance();

  //   return sf.getBool(userLoggedInKey);
  // }

  static Future<String?> getUserFirstName() async {
    final sf = await SharedPreferences.getInstance();

    return sf.getString(userFirstNameKey);
  }

  static Future<String?> getUserLastName() async {
    final sf = await SharedPreferences.getInstance();

    return sf.getString(userLastNameKey);
  }

  static Future<String?> getUserEmail() async {
    final sf = await SharedPreferences.getInstance();

    return sf.getString(userEmailKey);
  }
}
