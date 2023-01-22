import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../services/database_service.dart';
import '../services/auth_service.dart';

import '../widgets/custom_textbox.dart';
import '../widgets/my_snackbar.dart';

import './re_authantication_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-screen';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _numberFormKey = GlobalKey<FormState>();

  var _isNameLoading = false;
  var _isEmailLoading = false;
  var _isNumberLoading = false;

  var firstName = '';
  var lastName = '';
  var email = '';
  var phoneNumber = '';

  void _updateName() async {
    if (_nameFormKey.currentState!.validate()) {
      setState(() {
        _isNameLoading = true;
      });

      _nameFormKey.currentState!.save();

      await AuthService().nameUpdate(firstName, lastName);

      setState(() {
        _isNameLoading = false;
      });

      if (mounted) {
        MySnackbar.showSnackbar(context, black, 'Name updated Successfully');
      }
    }
  }

  void _updateEmail() async {
    if (_emailFormKey.currentState!.validate()) {
      setState(() {
        _isEmailLoading = true;
      });

      _emailFormKey.currentState!.save();

      dynamic value = await AuthService().emailUpdate(email);

      setState(() {
        _isEmailLoading = false;
      });

      if (value == true) {
        if (mounted) {
          MySnackbar.showSnackbar(
            context,
            black,
            'Email updated successfully. Use the updated email to sign in in future',
          );
        } else {
          if (mounted) {
            MySnackbar.showSnackbar(context, red, value);
          }
        }
      }
    }
  }

  void _updateNumber() async {
    if (_numberFormKey.currentState!.validate()) {
      _numberFormKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: DatabaseService().getUserDataUsingUid(
            FirebaseAuth.instance.currentUser!.uid,
          ),
          builder: (context, snapshot) => ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Text(
                          'Edit Profile',
                          style: sourceSansProBold.copyWith(
                            fontSize: 23,
                            color: grey,
                          ),
                        ),
                        const SizedBox(), // Place something here
                      ],
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: const NetworkImage(
                        commonMaleAvatar,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {},
                              child: const CircleAvatar(
                                backgroundColor: boxShadowColor,
                                child: Icon(
                                  color: black,
                                  Icons.edit,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: boxShadowColor),
                    const SizedBox(height: 25),
                    Form(
                      key: _nameFormKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'First name',
                            isHidden: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                            onSave: (value) {
                              firstName = value!.trim();
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'Last name',
                            isHidden: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            onSave: (value) {
                              lastName = value!.trim();
                            },
                          ),
                          TextButton(
                            onPressed: _updateName,
                            child: Text(
                              'Update Name',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: boxShadowColor),
                    const SizedBox(height: 5),
                    Form(
                      key: _emailFormKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextbox(
                            prefixIcon: Icons.email,
                            textInputType: TextInputType.emailAddress,
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ReAuthanticationScreen.routeName,
                              );
                            },
                            child: Text(
                              'Update Email',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: boxShadowColor),
                    const SizedBox(height: 5),
                    Form(
                      key: _numberFormKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextbox(
                            prefixIcon: Icons.phone,
                            textInputType: TextInputType.number,
                            labelData: 'Phone Number',
                            isHidden: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.contains(RegExp(r'[A-Za-z]'))) {
                                return 'Please enter valid phone number';
                              } else if (!(value.length == 10)) {
                                return 'Number should be exactly of 10 digits';
                              }

                              return null;
                            },
                          ),
                          TextButton(
                            onPressed: _updateNumber,
                            child: Text(
                              'Update Number',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
