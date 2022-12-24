import 'package:flutter/material.dart';

import '../app_styles.dart';

class MySnackbar {
  static void showSnackbar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: sourceSansProRegular.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
          textColor: white,
        ),
      ),
    );
  }
}
