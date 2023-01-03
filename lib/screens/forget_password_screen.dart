import 'package:flutter/material.dart';

import '../app_styles.dart';
import '../size_config.dart';
import '../widgets/custom_textbox.dart';
import '../widgets/my_snackbar.dart';
import '../services/auth_service.dart';

import './login_screen.dart';
import './home_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-password-screen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  var _isLoading = false;
  String email = '';

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      dynamic value = await authService.resetEmailPassword(email);

      if (value == true) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          MySnackbar.showSnackbar(context, Colors.black,
              'Password reset link sent to your email. Can\'t find the email? Check your spam folder or try \'Forget password\' again.');
        }

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      } else {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          MySnackbar.showSnackbar(context, red, value);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: lightOrange,
      appBar: AppBar(
        backgroundColor: lightOrange,
      ),
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
                    email = value!.trim();
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 8
                        : SizeConfig.blockSizeVertical! * 17,
                width: double.infinity,
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
              const SizedBox(height: 20),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 8
                        : SizeConfig.blockSizeVertical! * 17,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                      },
                      child: Text(
                        'Login',
                        style: sourceSansProBold.copyWith(
                          color: orange,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          HomeScreen.routeName,
                        );
                      },
                      child: Text(
                        'Continue without login',
                        style: sourceSansProBold.copyWith(
                          color: orange,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
