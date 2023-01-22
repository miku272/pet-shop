import 'package:flutter/material.dart';

import '../app_styles.dart';

class CustomTextbox extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? initValue;
  final String labelData;
  final IconData prefixIcon;
  final TextInputType? textInputType;
  final bool? isHidden;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;

  const CustomTextbox({
    this.textEditingController,
    this.initValue,
    required this.prefixIcon,
    required this.labelData,
    this.textInputType,
    this.isHidden,
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
        controller: textEditingController,
        initialValue: initValue,
        obscureText: isHidden ?? false,
        keyboardType: textInputType ?? TextInputType.text,
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
