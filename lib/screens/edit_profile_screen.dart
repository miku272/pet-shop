import 'package:flutter/material.dart';

import '../app_styles.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-screen';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Edit profile screen',
            style: sourceSansProBold.copyWith(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
