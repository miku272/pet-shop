import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/main_loading.dart';

import './add_pet_screen.dart';

class YourPostAndPetScreen extends StatefulWidget {
  static const routeName = '/your-post-and-pet-screen';

  const YourPostAndPetScreen({super.key});

  @override
  State<YourPostAndPetScreen> createState() => _YourPostAndPetScreenState();
}

class _YourPostAndPetScreenState extends State<YourPostAndPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your posts and pets',
          style: sourceSansProBold.copyWith(
            fontSize: 20,
            color: grey,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: FutureBuilder(
            future: DatabaseService().getPetDataUsingAuthorId(
              FirebaseAuth.instance.currentUser!.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MainLoading();
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Nothing here...',
                      style: sourceSansProSemiBold.copyWith(
                        fontSize: 20,
                        color: lightGrey,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['petName'],
                      style: sourceSansProSemiBold.copyWith(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 2,
                      ),
                    ),
                    subtitle: Text(
                      'Date Posted: ${snapshot.data!.docs[index]['datePosted']}',
                      style: sourceSansProRegular.copyWith(
                        fontSize: 18,
                        color: grey,
                        letterSpacing: 1,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Tooltip(
                            message: 'Edit',
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.edit,
                                color: boxShadowColor,
                              ),
                            ),
                          ),
                          Tooltip(
                            message: 'Delete',
                            child: InkWell(
                              onTap: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  animationType:
                                      DialogTransitionType.slideFromBottom,
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context) => AlertDialog(
                                    elevation: 5,
                                    alignment: Alignment.bottomCenter,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Text('Delete'),
                                    content: Text(
                                      'Are you sure you want to delete this post?',
                                      style: sourceSansProRegular.copyWith(
                                        color: grey,
                                        fontSize: 18,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          DatabaseService()
                                              .deletePetDataUsingUid(
                                            snapshot.data!.docs[index]['uid'],
                                          )
                                              .then((value) {
                                            setState(() {});
                                          });

                                          Navigator.of(context).pop();
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
                              child: const Icon(
                                Icons.delete,
                                color: red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
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
