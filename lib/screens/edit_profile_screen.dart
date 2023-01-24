import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
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

  final _controller = TextEditingController();

  var _isAvatarLoading = false;
  var _isNameLoading = false;
  var _isEmailLoading = false;
  var _isNumberLoading = false;

  var firstName = '';
  var lastName = '';
  var email = '';
  var phoneNumber = '';

  var avatar = 'm';

  void _selectAvatar() {
    if (avatar == 'm') {
      setState(() {
        avatar = 'f';
      });
    } else {
      setState(() {
        avatar = 'm';
      });
    }
  }

  void getAvatar() async {
    final avt = await DatabaseService().getAvatar();

    avatar = avt;
  }

  void _updateAvatar() async {
    setState(() {
      _isAvatarLoading = true;
    });

    await DatabaseService().updateAvatar(avatar);

    setState(() {
      _isAvatarLoading = false;
    });

    if (mounted) {
      MySnackbar.showSnackbar(context, black, 'Avatar updated successfully');
    }
  }

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
        _nameFormKey.currentState!.reset();
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
          _emailFormKey.currentState!.reset();

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

      setState(() {
        _isNumberLoading = true;
      });

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException error) {},
        codeSent: (String verificationId, int? resendToken) {
          showAnimatedDialog(
            context: context,
            animationType: DialogTransitionType.slideFromBottom,
            duration: const Duration(milliseconds: 300),
            builder: (context) => AlertDialog(
              elevation: 5,
              alignment: Alignment.bottomCenter,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Verify OTP'),
              content: CustomTextbox(
                textEditingController: _controller,
                prefixIcon: Icons.numbers,
                labelData: 'Enter OTP here',
                textInputType: TextInputType.number,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: sourceSansProSemiBold.copyWith(
                      color: orange,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    dynamic value = await AuthService().numberUpdate(
                      phoneNumber,
                      verificationId,
                      _controller.text,
                    );

                    if (value == true) {
                      if (mounted) {
                        MySnackbar.showSnackbar(
                          context,
                          black,
                          'Number Updated Successfully',
                        );

                        Navigator.of(context).pop();
                      }
                    } else {
                      if (mounted) {
                        MySnackbar.showSnackbar(
                          context,
                          black,
                          value,
                        );

                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(
                    'Verify',
                    style: sourceSansProSemiBold.copyWith(
                      color: orange,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );

      setState(() {
        _isNumberLoading = false;
      });
    }
  }

  @override
  void initState() {
    getAvatar();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _selectAvatar,
                          child: CircleAvatar(
                            radius: avatar == 'm' ? 60 : 40,
                            backgroundImage: const NetworkImage(
                              commonMaleAvatar,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _selectAvatar,
                          child: CircleAvatar(
                            radius: avatar == 'f' ? 60 : 40,
                            backgroundImage: const NetworkImage(
                              commonFemaleAvatar,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: _isAvatarLoading ? () {} : _updateAvatar,
                      child: _isAvatarLoading
                          ? const CircularProgressIndicator(
                              color: boxShadowColor)
                          : Text(
                              'Update Avatar',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
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
                            onPressed: _isNameLoading ? () {} : _updateName,
                            child: _isNameLoading
                                ? const CircularProgressIndicator(
                                    color: boxShadowColor)
                                : Text(
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
                            onPressed: () async {
                              final value =
                                  await Navigator.of(context).pushNamed(
                                ReAuthanticationScreen.routeName,
                              );

                              if (value == null) {
                                return;
                              }

                              if (value == true) {
                                _updateEmail();
                              } else {
                                if (mounted) {
                                  MySnackbar.showSnackbar(context, red, value);
                                }
                              }
                            },
                            child: _isEmailLoading
                                ? const CircularProgressIndicator(
                                    color: boxShadowColor,
                                  )
                                : Text(
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
                            textInputType: TextInputType.phone,
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
                            onSave: (value) {
                              phoneNumber = value!.trim();
                            },
                          ),
                          TextButton(
                            onPressed: () async {
                              final value =
                                  await Navigator.of(context).pushNamed(
                                ReAuthanticationScreen.routeName,
                              );

                              if (value == null) {
                                return;
                              }

                              if (value == true) {
                                _updateNumber();
                              } else {
                                if (mounted) {
                                  MySnackbar.showSnackbar(context, red, value);
                                }
                              }
                            },
                            child: _isNumberLoading
                                ? const CircularProgressIndicator(
                                    color: boxShadowColor,
                                  )
                                : Text(
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
