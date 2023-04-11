import 'package:flutter/material.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../services/helper_function.dart';
import '../widgets/my_snackbar.dart';
import '../widgets/custom_textbox.dart';
import '../services/auth_service.dart';
import './login_screen.dart';
import './home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration-page';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  bool _isLoading = false;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      dynamic value = await authService.registerUserWithEmailAndPassword(
          firstName, lastName, email, password);

      if (value == true) {
        // await HelperFunction.setUserLoggedInStatus(true);
        await HelperFunction.setUserFirstName(firstName);
        await HelperFunction.setUserLastName(lastName);
        await HelperFunction.setUserEmail(email);

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          },
                          child: Text(
                            textAlign: TextAlign.center,
                            'Continue without\nsign up',
                            style: sourceSansProSemiBold.copyWith(
                              color: orange,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'First Name',
                            isHidden: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'[a-z A-Z]+$').hasMatch(value)) {
                                return 'Please enter valid first name';
                              }

                              return null;
                            },
                            onSave: (value) {
                              firstName = value!.trim();
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'Last Name',
                            isHidden: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !RegExp(r'[a-z A-Z]+$').hasMatch(value)) {
                                return 'Please enter valid last name';
                              }

                              return null;
                            },
                            onSave: (value) {
                              lastName = value!.trim();
                            },
                          ),
                          const SizedBox(height: 15),
                          CustomTextbox(
                            prefixIcon: Icons.email_outlined,
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
                          const SizedBox(height: 15),
                          CustomTextbox(
                            prefixIcon: Icons.lock_outline,
                            labelData: 'Password',
                            isHidden: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }

                              if (value.length <= 6) {
                                return 'Please enter password of more than 6 characters';
                              }

                              return null;
                            },
                            onSave: (value) {
                              password = value!;
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
                            onTap: _isLoading ? () {} : _register,
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
                                        'Sign up',
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
                          onTap: _isLoading
                              ? () {}
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  dynamic value =
                                      await authService.loginUserWithGoogle();

                                  if (value[0] == true) {
                                    // await HelperFunction.setUserLoggedInStatus(true);
                                    await HelperFunction.setUserFirstName(
                                        value[1]);
                                    await HelperFunction.setUserLastName(
                                        value[2]);
                                    await HelperFunction.setUserEmail(value[3]);

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (mounted) {
                                      // Navigator.of(context).pushReplacementNamed(
                                      //     HomeScreen.routeName);

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        HomeScreen.routeName,
                                        (route) => false,
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (mounted) {
                                      MySnackbar.showSnackbar(
                                          context, red, value);
                                    }
                                  }
                                },
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
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
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
