import 'package:flutter/material.dart';

import '../app_styles.dart';

class CustomTextbox extends StatelessWidget {
  final String labelData;
  final IconData prefixIcon;
  final bool isHidden;
  final String? Function(String?)? validator;

  const CustomTextbox(
      this.prefixIcon, this.labelData, this.isHidden, this.validator,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: lightGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        obscureText: isHidden,
        keyboardType: TextInputType.emailAddress,
        cursorColor: grey,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: grey,
          ),
          label: Text(labelData),
          labelStyle: const TextStyle(
            color: lightGrey,
          ),
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
