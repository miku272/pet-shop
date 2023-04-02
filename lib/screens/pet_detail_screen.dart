import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../services/database_service.dart';

import '../widgets/main_loading.dart';
import '../widgets/my_snackbar.dart';

import './pet_editor_screen.dart';
import './chat_screen.dart';

class PetDetailScreen extends StatelessWidget {
  static const String routeName = '/pet-detail-screen';
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context)?.settings.arguments as String;

    return PetDetail(args);
  }
}

class PetDetail extends StatefulWidget {
  final String petId;
  const PetDetail(this.petId, {Key? key}) : super(key: key);

  @override
  State<PetDetail> createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  bool? isAuthor;
  String? authorId;
  var _isChatLoading = false;
  var isNewChat = false;
  var likedIcon = Icons.favorite_outline;

  Future getPetAuthorId() async {
    final snap =
        await DatabaseService().getPetDataUsinguid(widget.petId) as Map;

    authorId = snap['authorId'];

    if (FirebaseAuth.instance.currentUser!.uid == snap['authorId']) {
      setState(() {
        isAuthor = true;
      });
    } else {
      setState(() {
        isAuthor = false;
      });
    }

    if (snap['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        likedIcon = Icons.favorite;
      });
    }
  }

  onFavTap() async {
    if (FirebaseAuth.instance.currentUser == null) {
      MySnackbar.showSnackbar(context, black, 'Please Login First');

      return;
    }

    final snapshot =
        await DatabaseService().getPetDataUsinguid(widget.petId) as Map?;

    if (snapshot?['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      await DatabaseService().removeLike(
        widget.petId,
        FirebaseAuth.instance.currentUser!.uid,
      );

      setState(() {
        likedIcon = Icons.favorite_outline;
      });
    } else if (!(snapshot?['likedBy']
        .contains(FirebaseAuth.instance.currentUser!.uid))) {
      await DatabaseService().likePost(
        widget.petId,
        FirebaseAuth.instance.currentUser!.uid,
      );

      setState(() {
        likedIcon = Icons.favorite;
      });
    }
  }

  createChat(String authorId) async {
    setState(() {
      _isChatLoading = true;
    });

    if (FirebaseAuth.instance.currentUser == null) {
      MySnackbar.showSnackbar(context, black, 'Please Login First');

      return;
    }

    final senderData = await DatabaseService().getUserDataUsingUid(
      FirebaseAuth.instance.currentUser!.uid,
    );

    if (senderData.docs[0].data()!['chats'].isNotEmpty &&
        senderData.docs[0].data()!['chats'] != null) {
      for (String chatId in senderData.docs[0].data()!['chats']) {
        isNewChat = true;

        final chatData =
            await DatabaseService().getStaticChatDataUsingUid(chatId);

        // if (chatData.data()!['senderId'] ==
        //         FirebaseAuth.instance.currentUser!.uid ||
        //     chatData.data()!['receiverId'] == authorId) {
        if (chatData.data()!['senderId'] == authorId ||
            chatData.data()!['receiverId'] == authorId) {
          isNewChat = false;

          if (mounted) {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: chatId,
            );
          }

          setState(() {
            _isChatLoading = false;
          });

          break;
        }
      }
    } else {
      isNewChat = true;
    }

    if (isNewChat) {
      final newChatId = await DatabaseService().createChat(
        FirebaseAuth.instance.currentUser!.uid,
        authorId,
      );

      setState(() {
        _isChatLoading = false;
      });

      if (mounted) {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: newChatId,
        );
      }
    }
  }

  @override
  void initState() {
    getPetAuthorId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: DatabaseService().getPetDataUsinguid(
              widget.petId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: MainLoading(),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
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

              var data = snapshot.data as Map?;
              var imageList = data?['imageList'] as List<dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 50,
                    child: Stack(
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            height: SizeConfig.blockSizeVertical! * 50,
                            enableInfiniteScroll: false,
                          ),
                          items: imageList.map((imageLink) {
                            return Builder(
                              builder: (context) => Image.network(
                                // 'assets/images/dog_marly_cover.png',
                                imageLink,
                                height: SizeConfig.blockSizeVertical! * 50,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                'assets/arrow_left_icon.svg',
                              ),
                            ),
                          ),
                        ),
                        if (isAuthor == true && isAuthor != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    PetEditorScreen.routeName,
                                    arguments: {
                                      'isEditing': true,
                                      'petId': data?['uid'],
                                      'imageList': data?['imageList'],
                                      'petType': data?['petType'],
                                      'avlForAdopt': data?['avlForAdopt'],
                                      'petName': data?['petName'],
                                      'petBreed': data?['petBreed'],
                                      'petAge': data?['petAge'],
                                      'petColor': data?['petColor'],
                                      'petWeight': data?['petWeight'],
                                      'location': data?['location'],
                                      'description': data?['description'],
                                    },
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    transform: Matrix4.translationValues(0, -12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data?['petName'],
                              style: sourceSansProBold.copyWith(
                                fontSize: 25,
                                color: grey,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: lightGrey,
                                  size: 15,
                                ),
                                Text(
                                  data?['location'],
                                  style: sourceSansProMedium.copyWith(
                                    fontSize: 15,
                                    color: lightGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: onFavTap,
                              child: Icon(
                                likedIcon,
                                color: red,
                                size: 30,
                              ),
                            ),
                            data?['likedBy'].isNotEmpty
                                ? Text(
                                    '${data?['likedBy'].length}',
                                    style: sourceSansProRegular.copyWith(
                                      color: grey,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: lighterOrange,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${data?['petAge']} Months',
                                style: sourceSansProBold.copyWith(
                                  color: darkOrange,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Age',
                                style: sourceSansProRegular.copyWith(
                                  color: lightGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: lighterOrange,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                data?['petColor'],
                                style: sourceSansProBold.copyWith(
                                  color: darkOrange,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Color',
                                style: sourceSansProRegular.copyWith(
                                  color: lightGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: lighterOrange,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${data?['petWeight']} KG',
                                style: sourceSansProBold.copyWith(
                                  color: darkOrange,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Weight',
                                style: sourceSansProRegular.copyWith(
                                  color: lightGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal),
                    child: Text(
                      'About Me',
                      style: sourceSansProRegular.copyWith(
                        color: lightGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal),
                    child: Text(
                      data?['description'],
                      style: sourceSansProBold.copyWith(
                        color: grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: (isAuthor != null && isAuthor == false)
          ? FloatingActionButton.extended(
              onPressed: _isChatLoading
                  ? () {}
                  : () {
                      if (authorId != null) {
                        createChat(authorId!);
                      }
                    },
              extendedPadding: const EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: grey,
              label: _isChatLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: boxShadowColor,
                      ),
                    )
                  : const Text(
                      'Ask for adoption',
                      style: TextStyle(
                        color: boxShadowColor,
                      ),
                    ),
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: boxShadowColor,
              ),
            )
          : FirebaseAuth.instance.currentUser == null
              ? FloatingActionButton.extended(
                  onPressed: () {
                    MySnackbar.showSnackbar(
                        context, black, 'Please Login First');

                    return;
                  },
                  extendedPadding: const EdgeInsets.symmetric(
                    horizontal: paddingHorizontal,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: grey,
                  label: _isChatLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: boxShadowColor,
                          ),
                        )
                      : const Text(
                          'Ask for adoption',
                          style: TextStyle(
                            color: boxShadowColor,
                          ),
                        ),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: boxShadowColor,
                  ),
                )
              : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
