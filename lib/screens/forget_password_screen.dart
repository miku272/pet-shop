import 'package:flutter/material.dart';

import '../app_styles.dart';
import '../size_config.dart';
import '../widgets/custom_textbox.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-password-screen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  var _isLoading = false;

  void _resetPassword() async {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: lightOrange,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                'Enter your email. You will recieve password reset link on your email',
                style: sourceSansProBold.copyWith(
                  color: grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: CustomTextbox(
                  prefixIcon: Icons.email,
                  labelData: 'Email',
                  isHidden: false,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                      return 'Please enter valid email';
                    }

                    return null;
                  },
                  onSave: (value) {
                    email = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 8
                        : SizeConfig.blockSizeVertical! * 17,
                child: Expanded(
                  child: InkWell(
                    onTap: _isLoading ? () {} : _resetPassword,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 19,
                        horizontal: 63,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: boxShadowColor,
                              )
                            : Text(
                                'Reset Password',
                                style: sourceSansProBold.copyWith(
                                  color: boxShadowColor,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
