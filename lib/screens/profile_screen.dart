import 'package:flutter/material.dart';

import '../app_styles.dart';

import '../widgets/drawer_icon_button.dart';
import '../widgets/custom_app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: SafeArea(
        child: ListView(
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
                      const DrawerIconButton(),
                      Text(
                        'Your Profile',
                        style: sourceSansProBold.copyWith(
                          fontSize: 23,
                          color: grey,
                        ),
                      ),
                      const SizedBox(), // Place something here
                    ],
                  ),
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
