import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../app_styles.dart';

import '../widgets/drawer_icon_button.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/profile_screen_list_tile.dart';

import '../services/auth_service.dart';

import './home_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _shareApp() async {
    await Share.share(
      'Hey! Check out this cool app!\nwww . pet_shop . com',
    );
  }

  void _logout() {
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
        title: const Text('Logout'),
        content: Text(
          'Are you sure you want to logout?',
          style: sourceSansProRegular.copyWith(
            color: grey,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await AuthService().signOut();

              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (route) => false,
                );
              }
            },
            child: Text(
              'Yes',
              style: sourceSansProSemiBold.copyWith(
                color: orange,
                fontSize: 20,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'No',
              style: sourceSansProSemiBold.copyWith(
                color: orange,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  const SizedBox(height: 10),
                  Text(
                    'Naresh Sharma',
                    style: sourceSansProBold.copyWith(
                      fontSize: 25,
                      color: black,
                    ),
                  ),
                  Text(
                    'sharmanaresh272@gmail.com',
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 22,
                      color: grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: 5,
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: sourceSansProMedium.copyWith(
                        color: white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Divider(color: boxShadowColor),
                  const SizedBox(height: 20),
                  const ProfileScreenListTile(
                    leadIcon: Icons.settings,
                    title: 'Settings',
                    trailIcon: Icons.arrow_right_rounded,
                  ),
                  const ProfileScreenListTile(
                    leadIcon: Icons.settings,
                    title: 'Settings',
                    trailIcon: Icons.arrow_right_rounded,
                  ),
                  const ProfileScreenListTile(
                    leadIcon: Icons.settings,
                    title: 'Settings',
                    trailIcon: Icons.arrow_right_rounded,
                  ),
                  const Divider(color: boxShadowColor),
                  ProfileScreenListTile(
                    onPress: _shareApp,
                    leadIcon: Icons.share,
                    title: 'Share this app',
                  ),
                  ProfileScreenListTile(
                    onPress: _logout,
                    leadIcon: Icons.logout,
                    title: 'log out',
                    titleColor: red,
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
