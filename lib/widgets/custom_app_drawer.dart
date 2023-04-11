import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/wishlist_screen.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  QuerySnapshot? qureySnapshot;

  void _getCurrentUserData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String email = FirebaseAuth.instance.currentUser!.email!;
      qureySnapshot = await DatabaseService().getUserDataUsingEmail(email);
      setState(() {});
    }
  }

  void _shareApp() async {
    await Share.share(
      'Hey! Check out this cool app!\nwww . pawpals . com',
    );
  }

  @override
  void initState() {
    super.initState();

    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                color: lightOrange,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(
                          top: 30,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              qureySnapshot?.docs != null
                                  ? qureySnapshot!.docs[0]['avatar'] == 'm'
                                      ? commonMaleAvatar
                                      : commonFemaleAvatar
                                  : commonMaleAvatar,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        qureySnapshot == null
                            ? 'Hello User'
                            : '${qureySnapshot!.docs[0]['firstName']} ${qureySnapshot!.docs[0]['lastName']}',
                        style: sourceSansProSemiBold.copyWith(
                          fontSize: 22,
                          color: lightGrey,
                        ),
                      ),
                      qureySnapshot != null
                          ? const SizedBox(height: 10)
                          : const SizedBox(),
                      Text(
                        qureySnapshot == null
                            ? ''
                            : '${qureySnapshot!.docs[0]['email']}',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 15,
                          color: lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: Text(
                  'Home',
                  style: sourceSansProRegular.copyWith(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName,
                    (route) => false,
                  );
                },
              ),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.delivery_dining_outlined),
                      title: Text(
                        'Orders',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          OrdersScreen.routeName,
                          (route) => false,
                        );
                      },
                    )
                  : const SizedBox(),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(
                        'Profile',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          ProfileScreen.routeName,
                        );
                      },
                    )
                  : const SizedBox(),
              ListTile(
                leading: const Icon(Icons.pets_outlined),
                title: Text(
                  'Pet Care',
                  style: sourceSansProRegular.copyWith(
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    ProductListScreen.routeName,
                  );
                },
              ),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.card_travel),
                      title: Text(
                        'Cart',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          CartScreen.routeName,
                        );
                      },
                    )
                  : const SizedBox(),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text(
                        'My wishlist',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          WishlistScreen.routeName,
                        );
                      },
                    )
                  : const SizedBox(),
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(
                  'Share this app',
                  style: sourceSansProRegular.copyWith(
                    fontSize: 20,
                  ),
                ),
                onTap: _shareApp,
              ),
              FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(
                        'Sign out',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () async {
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
                                    Navigator.of(context).pushReplacementNamed(
                                      HomeScreen.routeName,
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
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.login),
                      title: Text(
                        'Sign in',
                        style: sourceSansProRegular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName,
                          (route) => false,
                        );
                      },
                    ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Center(
              child: Text(
                'Copyright©️ 2023    Paw Pals',
                style: sourceSansProRegular.copyWith(
                  color: grey,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
