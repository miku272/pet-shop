import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../widgets/main_loading.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/profile_screen_list_tile.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';

import './home_screen.dart';
import './edit_profile_screen.dart';
import './your_post_and_pet_screen.dart';
import './address_screen.dart';
import './update_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
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
        child: FutureBuilder(
          future: DatabaseService().getUserDataUsingUid(
            FirebaseAuth.instance.currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: MainLoading(),
              );
            }

            if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Something Went Wrong...',
                      style: sourceSansProRegular.copyWith(
                        color: grey,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        'Refresh',
                        style: sourceSansProSemiBold.copyWith(
                          color: boxShadowColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView(
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
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                          snapshot.data.docs[0]['avatar'] == 'm'
                              ? commonMaleAvatar
                              : commonFemaleAvatar,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${snapshot.data.docs[0]['firstName']} ${snapshot.data.docs[0]['lastName']}',
                        style: sourceSansProBold.copyWith(
                          fontSize: 25,
                          color: black,
                        ),
                      ),
                      Text(
                        snapshot.data.docs[0]['email'],
                        style: sourceSansProSemiBold.copyWith(
                          fontSize: 22,
                          color: grey,
                        ),
                      ),
                      snapshot.data.docs[0]['number'] != null
                          ? Text(
                              '+91 ${snapshot.data.docs[0]['number']}',
                              style: sourceSansProSemiBold.copyWith(
                                fontSize: 22,
                                color: grey,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                            EditProfileScreen.routeName,
                          )
                              .then((value) {
                            setState(() {});
                          });
                        },
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
                      ProfileScreenListTile(
                        onPress: () {
                          Navigator.of(context).pushNamed(
                            YourPostAndPetScreen.routeName,
                          );
                        },
                        leadIcon: Icons.pets,
                        title: 'Your posts and pets',
                        trailIcon: Icons.arrow_right_rounded,
                      ),
                      ProfileScreenListTile(
                        onPress: () {
                          Navigator.of(context).pushNamed(
                            AddressScreen.routeName,
                          );
                        },
                        leadIcon: Icons.location_city,
                        title: 'Your Addresses',
                        trailIcon: Icons.arrow_right_rounded,
                      ),
                      ProfileScreenListTile(
                        onPress: () {
                          Navigator.of(context).pushNamed(
                            UpdatePasswordScreen.routeName,
                          );
                        },
                        leadIcon: Icons.key,
                        title: 'Update Password',
                        trailIcon: Icons.arrow_right_rounded,
                      ),
                      const Divider(color: boxShadowColor),
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
            );
          },
        ),
      ),
    );
  }
}
