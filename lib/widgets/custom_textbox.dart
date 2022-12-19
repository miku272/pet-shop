import 'package:flutter/material.dart';

import '../app_styles.dart';

class CustomTextbox extends StatelessWidget {
  final String labelData;
  final IconData prefixIcon;
  final bool isHidden;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;

  const CustomTextbox({
    required this.prefixIcon,
    required this.labelData,
    required this.isHidden,
    this.validator,
    this.onSave,
    super.key,
  });

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
        onSaved: onSave,
      ),
    );
  }
}
