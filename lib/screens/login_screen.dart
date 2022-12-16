import 'package:flutter/material.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../widgets/custom_textbox.dart';
import '../screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var temp =
      []; // This variable is created only to store the values entered by users. Marked for deletion later

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // print(temp); // Use this to check the values entered by users, in debug console. Marked for deletion later
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: lighterOrange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/login_top.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Login',
                              style: sourceSansProBold.copyWith(
                                fontSize: 25,
                                color: grey,
                              ),
                            ),
                            Text(
                              'Sign in to continue',
                              style: sourceSansProRegular.copyWith(
                                fontSize: 15,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextbox(
                            Icons.email_outlined,
                            'Email',
                            false,
                            (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                      .hasMatch(value)) {
                                return 'Please enter valid email';
                              }

                              return null;
                            },
                            (value) {
                              temp.add(value!.trim());
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextbox(
                            Icons.lock_outline,
                            'Password',
                            true,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }

                              if (value.length <= 6) {
                                return 'Please enter password of more than 6 characters';
                              }

                              return null;
                            },
                            (value) {
                              temp.add(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Forget Password?',
                            style: sourceSansProBold.copyWith(
                              color: orange,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: _saveForm,
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
                                child: Text(
                                  'Sign in',
                                  style: sourceSansProBold.copyWith(
                                    color: boxShadowColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 14,
                            ),
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: lightOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'G',
                                style: sourceSansProBold.copyWith(
                                  color: orange,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account? ',
                          style: sourceSansProBold.copyWith(
                            color: grey,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                              RegistrationScreen.routeName,
                            );
                          },
                          child: Text(
                            'Signup ',
                            style: sourceSansProBold.copyWith(
                              color: orange,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          'now',
                          style: sourceSansProBold.copyWith(
                            color: grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
