import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_styles.dart';
import '../size_config.dart';
import '../widgets/custom_textbox.dart';
import '../widgets/my_snackbar.dart';
import '../services/auth_service.dart';

import './login_screen.dart';

class UpdatePasswordScreen extends StatefulWidget {
  static const routeName = '/update-password-screen';
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  var _isLoading = false;
  String currPassword = '';
  String newPassword = '';

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      dynamic value = await authService.passwordUpdate(
        FirebaseAuth.instance.currentUser!.email!,
        currPassword,
        newPassword,
      );

      if (value == true) {
        setState(() {
          _isLoading = false;
        });

        authService.signOut();

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false,
          );
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
                'Enter your current and new password',
                style: sourceSansProBold.copyWith(
                  color: grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextbox(
                      prefixIcon: Icons.password,
                      labelData: 'current password',
                      isHidden: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid password';
                        }

                        return null;
                      },
                      onSave: (value) {
                        currPassword = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextbox(
                      prefixIcon: Icons.key,
                      labelData: 'new password',
                      isHidden: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid password';
                        } else if (value.length < 6) {
                          return 'Password length must be greater than 5 characters';
                        }

                        return null;
                      },
                      onSave: (value) {
                        newPassword = value!;
                      },
                    ),
                  ],
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
                  onTap: _isLoading ? () {} : _updatePassword,
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
                              'Update Password',
                              style: sourceSansProBold.copyWith(
                                color: boxShadowColor,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'NOTE: You will have to login again after ressetting password\n\nNOTE: This will only work if you have signed in using email and password',
                style: sourceSansProSemiBold.copyWith(
                  color: red,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
