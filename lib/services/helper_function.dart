import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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

    final firstName = sf.getString(userFirstNameKey);

    if (firstName != '') {
      return firstName;
    } else {
      return null;
    }
  }

  static Future<String?> getUserLastName() async {
    final sf = await SharedPreferences.getInstance();

    final lastName = sf.getString(userLastNameKey);

    if (lastName != '') {
      return lastName;
    } else {
      return null;
    }
  }

  static Future<String?> getUserEmail() async {
    final sf = await SharedPreferences.getInstance();

    final email = sf.getString(userEmailKey);

    if (email != '') {
      return email;
    } else {
      return null;
    }
  }

  static Future<File?> getImage(String imageSource) async {
    final imagePicker = ImagePicker();
    XFile? xFile;
    File? file;

    if (imageSource == 'gallery') {
      xFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        file = File(xFile.path);

        return file;
      } else {
        return null;
      }
    } else if (imageSource == 'camera') {
      xFile = await imagePicker.pickImage(source: ImageSource.camera);

      if (xFile != null) {
        file = File(xFile.path);

        return file;
      } else {
        return null;
      }
    }

    return null;
  }
}
