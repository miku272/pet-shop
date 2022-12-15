import 'package:flutter/material.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../widgets/custom_textbox.dart';
import '../screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration-page';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var _isValidated = false;
  final _formKey = GlobalKey<FormState>();

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
                              'Register',
                              style: sourceSansProBold.copyWith(
                                fontSize: 25,
                                color: grey,
                              ),
                            ),
                            Text(
                              'Sign up to continue',
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
                            Icons.person,
                            'Your Name',
                            false,
                            (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'[a-z A-Z]+$').hasMatch(value)) {
                                return 'Please enter valid name';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
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
                          ),
                          SizedBox(height: 15),
                          CustomTextbox(
                            Icons.lock_outline,
                            'Password',
                            true,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: _isValidated ? () {} : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 19,
                                horizontal: 63,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _isValidated ? grey : lightOrange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign up',
                                  style: sourceSansProBold.copyWith(
                                    color: _isValidated
                                        ? boxShadowColor
                                        : lightGrey,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isValidated = !_isValidated;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 14,
                            ),
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: grey,
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
                          'Already have an account? ',
                          style: sourceSansProBold.copyWith(
                            color: grey,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                              LoginScreen.routeName,
                            );
                          },
                          child: Text(
                            'Sign in ',
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
