import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/custom_textbox.dart';

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

  void reauth() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
