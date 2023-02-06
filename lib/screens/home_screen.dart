import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../widgets/drawer_icon_button.dart';
import '../widgets/pet_container.dart';
import '../widgets/custom_app_drawer.dart';

import '../services/database_service.dart';

import './login_screen.dart';
import './pet_detail_screen.dart';
import './chat_list_screen.dart';
import './add_pet_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Good Morning,',
            style: sourceSansProSemiBold.copyWith(
              fontSize: 25,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Start your day with great energy!',
            style: sourceSansProMedium.copyWith(
              color: grey,
              fontSize: 20,
            ),
          ),
          Text(
            '🌅🌅🌅',
            style: sourceSansProMedium.copyWith(
              color: grey,
              fontSize: 20,
            ),
          ),
        ],
      ); // For Morning
    }
    if (hour < 17) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Good Afternoon,',
            style: sourceSansProSemiBold.copyWith(
              fontSize: 25,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'It\'s time for some nap. Isn\'t it?',
            style: sourceSansProMedium.copyWith(
              color: grey,
              fontSize: 20,
            ),
          ),
          Text(
            '😪😪😪',
            style: sourceSansProMedium.copyWith(
              color: grey,
              fontSize: 20,
            ),
          ),
        ],
      ); // For Afternoon
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Good Evening,',
          style: sourceSansProSemiBold.copyWith(
            fontSize: 25,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          'Hope your day went well',
          style: sourceSansProMedium.copyWith(
            color: grey,
            fontSize: 20,
          ),
        ),
        Text(
          '🌆🌆🌆',
          style: sourceSansProMedium.copyWith(
            color: grey,
            fontSize: 20,
          ),
        ),
      ],
    ); // For Evening
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<String> dogs = [
      'dog_marly.png',
      'dog_marly02.png',
      'dog_cocoa.png',
      'dog_walt.png',
    ];

    List<String> cats = [
      'cat_alyx.png',
      'cat_brook.png',
      'cat_marly.png',
    ];

    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const DrawerIconButton(),
                  Text(
                    'Pet Shop',
                    style: sourceSansProBold.copyWith(
                      fontSize: 23,
                      color: grey,
                    ),
                  ),
                  FirebaseAuth.instance.currentUser == null
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text(
                            'Login',
                            style: sourceSansProSemiBold.copyWith(
                              color: lightGrey,
                              fontSize: 16.5,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ChatListScreen.routeName,
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: const <Widget>[
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: grey,
                              ),
                              // temp
                              //     ? Positioned(
                              //         top: -10,
                              //         right: -10,
                              //         child: CircleAvatar(
                              //           backgroundColor: boxShadowColor,
                              //           radius: 10,
                              //           child: Center(
                              //             child: Text(
                              //               '1',
                              //               style: sourceSansProSemiBold
                              //                   .copyWith(color: black),
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     : const SizedBox(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: lighterOrange,
                      blurRadius: 20,
                      spreadRadius: 0.9,
                    )
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: white,
                  ),
                  child: greeting(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/welcome_message.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: SizeConfig.blockSizeHorizontal! * 38,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              'Hello ',
                              style: sourceSansProLight.copyWith(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 5.5,
                                  color: black),
                            ),
                            FirebaseAuth.instance.currentUser != null
                                ? FutureBuilder(
                                    initialData: 'User👋',
                                    future: DatabaseService()
                                        .getUserDataUsingEmail(FirebaseAuth
                                            .instance.currentUser!.email!),
                                    builder: (context, snapshot) => snapshot
                                                .connectionState ==
                                            ConnectionState.waiting
                                        ? const SizedBox()
                                        : Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: paddingHorizontal,
                                              ),
                                              child: Text(
                                                textAlign: TextAlign.left,
                                                snapshot.hasData
                                                    ? '${snapshot.data.docs[0]['firstName'].toString()}👋'
                                                    : 'User👋',
                                                style: sourceSansProMedium
                                                    .copyWith(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      5.5,
                                                  color: black,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                  )
                                : Text(
                                    textAlign: TextAlign.left,
                                    'User👋',
                                    style: sourceSansProMedium.copyWith(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 5.5,
                                      color: black,
                                    ),
                                  ),
                            // Text(
                            //   textAlign: TextAlign.left,
                            //   'User 👋',
                            //   style: sourceSansProMedium.copyWith(
                            //       fontSize:
                            //           SizeConfig.blockSizeHorizontal! * 5.5,
                            //       color: black),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.left,
                          'Ready for an amazing and lucky experience 🐈 🐕',
                          style: sourceSansProRegular.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                            color: black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Text(
                'Dogs 🐕',
                style: sourceSansProBold.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 200
                  : 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dogs.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PetDetailScreen.routeName);
                  },
                  child: PetContainer(
                    totalLength: dogs.length,
                    index: index,
                    petImage: 'assets/images/${dogs[index]}',
                    petName: 'Charlie',
                    petBreed: 'Marly',
                    postingDate: '17 Nov 2022',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Text(
                'Cats 🐈',
                style: sourceSansProBold.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 200
                  : 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PetDetailScreen.routeName);
                  },
                  child: PetContainer(
                    totalLength: cats.length,
                    index: index,
                    petImage: 'assets/images/${cats[index]}',
                    petName: 'Golden',
                    petBreed: 'Alyx',
                    postingDate: '21 Nov 2022',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: boxShadowColor,
        tooltip: 'Add Pet',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AddPetScreen.routeName);
        },
        child: const Center(
          child: Icon(
            Icons.pets,
            size: 30,
            color: black,
          ),
        ),
      ),
    );
  }
}
