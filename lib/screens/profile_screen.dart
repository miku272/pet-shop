import 'package:flutter/material.dart';

import '../app_styles.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            'Profile Screen',
            style: sourceSansProBold.copyWith(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
