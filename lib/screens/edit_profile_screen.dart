import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/custom_textbox.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-screen';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
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
                        const DrawerIconButton(),
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
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'First name',
                            isHidden: false,
                          ),
                          const SizedBox(height: 10),
                          const CustomTextbox(
                            prefixIcon: Icons.person,
                            labelData: 'Last name',
                            isHidden: false,
                          ),
                          const SizedBox(height: 10),
                          const CustomTextbox(
                            prefixIcon: Icons.email,
                            textInputType: TextInputType.emailAddress,
                            labelData: 'Email',
                            isHidden: false,
                          ),
                          const SizedBox(height: 10),
                          const CustomTextbox(
                            prefixIcon: Icons.phone,
                            textInputType: TextInputType.number,
                            labelData: 'Phone Number',
                            isHidden: false,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
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
