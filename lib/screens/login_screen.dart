import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_shop/services/database_service.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../widgets/my_snackbar.dart';
import '../widgets/custom_textbox.dart';
import '../services/auth_service.dart';
import '../services/helper_function.dart';
import './registration_screen.dart';
import './forget_password_screen.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  bool _isLoading = false;
  String email = '';
  String password = '';

  void _signin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      dynamic value =
          await authService.loginUserWithEmailAndPassword(email, password);

      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .getUserDataUsingEmail(email);

        // await HelperFunction.setUserLoggedInStatus(true);
        await HelperFunction.setUserFirstName(snapshot.docs[0]['firstName']);
        await HelperFunction.setUserLastName(snapshot.docs[0]['lastName']);
        await HelperFunction.setUserEmail(email);

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          },
                          child: Text(
                            'Continue without login',
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
                            textInputType: TextInputType.text,
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
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ForgetPasswordScreen.routeName);
                          },
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
                            onTap: _isLoading ? () {} : _signin,
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
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                dynamic value =
                                    await authService.loginUserWithGoogle();

                                if (value == true) {
                                  // await HelperFunction.setUserLoggedInStatus(true);
                                  // await HelperFunction.setUserFirstName(
                                  //     value[1]);
                                  // await HelperFunction.setUserLastName(
                                  //     value[2]);
                                  // await HelperFunction.setUserEmail(value[3]);

                                  // print(
                                  //     await HelperFunction.getUserFirstName());
                                  // print(await HelperFunction.getUserLastName());
                                  // print(await HelperFunction.getUserEmail());

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  if (mounted) {
                                    Navigator.of(context).pushReplacementNamed(
                                        HomeScreen.routeName);
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
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: boxShadowColor,
                                      )
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
