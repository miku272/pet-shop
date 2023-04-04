import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../widgets/drawer_icon_button.dart';
import '../widgets/pet_container.dart';
import '../widgets/custom_app_drawer.dart';
import '../widgets/my_snackbar.dart';
import '../widgets/main_loading.dart';

import '../services/database_service.dart';

import './login_screen.dart';
import './pet_detail_screen.dart';
import './chat_list_screen.dart';
import 'pet_editor_screen.dart';

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
            'Start your day with great energy! 🌅',
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
            'It\'s time for some nap. Isn\'t it? 😪',
            style: sourceSansProMedium.copyWith(
              color: grey,
              fontSize: 20,
            ),
          ),
        ],
      );
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
          'Hope your day went well 🌆',
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

    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leading: const DrawerIconButton(),
        leadingWidth: 100,
        title: Text(
          'Paw Pals',
          style: sourceSansProBold.copyWith(
            fontSize: 23,
            color: grey,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          FirebaseAuth.instance.currentUser == null
              ? Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      'Login',
                      style: sourceSansProSemiBold.copyWith(
                        color: lightGrey,
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: InkWell(
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
                      ],
                    ),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: greeting(),
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
              child: FutureBuilder(
                future: DatabaseService().getDogPetDataForHomeScreen(),
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

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PetDetailScreen.routeName,
                          arguments: snapshot.data!.docs[index]['uid'],
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: PetContainer(
                        totalLength: snapshot.data!.docs.length,
                        index: index,
                        petId: snapshot.data!.docs[index]['uid'],
                        petImageUrl: snapshot.data!.docs[index]['imageList'][0],
                        petName: snapshot.data!.docs[index]['petName'],
                        petBreed: snapshot.data!.docs[index]['petBreed'],
                        postingDate: snapshot.data!.docs[index]['datePosted'],
                      ),
                    ),
                  );
                },
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
              child: FutureBuilder(
                future: DatabaseService().getCatPetDataForHomeScreen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: MainLoading(),
                    );
                  }

                  if (snapshot.data == null) {
                    return Center(
                      child: Column(
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

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PetDetailScreen.routeName,
                          arguments: snapshot.data!.docs[index]['uid'],
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: PetContainer(
                        totalLength: snapshot.data!.docs.length,
                        index: index,
                        petId: snapshot.data!.docs[index]['uid'],
                        petImageUrl: snapshot.data!.docs[index]['imageList'][0],
                        petName: snapshot.data!.docs[index]['petName'],
                        petBreed: snapshot.data!.docs[index]['petBreed'],
                        postingDate: snapshot.data!.docs[index]['datePosted'],
                      ),
                    ),
                  );
                },
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
          if (FirebaseAuth.instance.currentUser == null) {
            MySnackbar.showSnackbar(context, black, 'Please signin first');
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else {
            Navigator.of(context)
                .pushNamed(PetEditorScreen.routeName)
                .then((value) {
              setState(() {});
            });
          }
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
