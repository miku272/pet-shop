import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../widgets/custom_textbox.dart';

import '../services/auth_service.dart';

class ReAuthanticationScreen extends StatefulWidget {
  static const routeName = '/reauth-screen';

  const ReAuthanticationScreen({Key? key}) : super(key: key);

  @override
  State<ReAuthanticationScreen> createState() => _ReAuthanticationScreenState();
}

class _ReAuthanticationScreenState extends State<ReAuthanticationScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  var password = '';

  void _reauth() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      dynamic value = await AuthService()
          .reauthUser(FirebaseAuth.instance.currentUser!.email!, password);

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pop(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighterOrange,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Please Enter your password to continue',
                  textAlign: TextAlign.center,
                  style: sourceSansProSemiBold.copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: CustomTextbox(
                    prefixIcon: Icons.key,
                    labelData: 'Password',
                    isHidden: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid password';
                      }

                      return null;
                    },
                    onSave: (value) {
                      password = value!;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _isLoading ? () {} : _reauth,
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
                              'Submit',
                              style: sourceSansProBold.copyWith(
                                color: boxShadowColor,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
