import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';
import '../app_styles.dart';

import '../services/database_service.dart';

import './chat_screen.dart';

class PetDetailScreen extends StatefulWidget {
  static const String routeName = '/pet-detail-screen';
  const PetDetailScreen({Key? key}) : super(key: key);

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  var _isChatLoading = false;
  var isNewChat = false;

  createChat() async {
    setState(() {
      _isChatLoading = true;
    });

    final senderData = await DatabaseService().getUserDataUsingUid(
      FirebaseAuth.instance.currentUser!.uid,
    );

    if (senderData.docs[0].data()!['chats'].isNotEmpty &&
        senderData.docs[0].data()!['chats'] != null) {
      for (String chatId in senderData.docs[0].data()!['chats']) {
        isNewChat = true;

        final chatData =
            await DatabaseService().getStaticChatDataUsingUid(chatId);

        if (chatData.data()!['senderId'] == 'MHJo8F9IrVPmA7FIdwQBUAH8aVn1' ||
            chatData.data()!['receiverId'] == 'MHJo8F9IrVPmA7FIdwQBUAH8aVn1') {
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
        '7Ymz94J2UTgSk6ZbOfX8UoTe3jk1',
        'MHJo8F9IrVPmA7FIdwQBUAH8aVn1',
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

    // await DatabaseService().createChat(
    //   '7Ymz94J2UTgSk6ZbOfX8UoTe3jk1',
    //   'MHJo8F9IrVPmA7FIdwQBUAH8aVn1',
    // );

    // setState(() {
    //   _isChatLoading = false;
    // });

    // if (mounted) {
    //   Navigator.of(context).pushNamed(ChatListScreen.routeName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isChatLoading ? () {} : createChat,
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
        // icon: SvgPicture.asset('assets/add_to_cart_icon.svg'),
        icon: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: boxShadowColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 50,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/dog_marly_cover.png',
                      height: SizeConfig.blockSizeVertical! * 50,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                          child: SvgPicture.asset('assets/arrow_left_icon.svg'),
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
                          'Marly',
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
                              ' Arizona, U.S.',
                              style: sourceSansProMedium.copyWith(
                                fontSize: 15,
                                color: lightGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset('assets/favorite_icon.svg'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                            '6 Months',
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
                            'Brown',
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
                            '6 KG',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Text(
                  'About Me',
                  style: sourceSansProRegular.copyWith(
                    color: lightGrey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Text(
                  'Remember this sweet face? Several years ago Charlie came into our care when their person died. These two easy going Lhasa Apso mixes quickly to settle into foster care. Living with kids, cats and other dogs, they were the perfect guests, and once their vetting and evaluation was done this bonded pair found their home with a kind couple.',
                  style: sourceSansProBold.copyWith(
                    color: grey,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Text(
                  'Photo Album',
                  style: sourceSansProRegular.copyWith(
                    color: lightGrey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? SizeConfig.blockSizeVertical! * 40
                            : 75,
                        width: SizeConfig.blockSizeHorizontal! * 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/dog_marly01.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? SizeConfig.blockSizeVertical! * 40
                            : 75,
                        width: SizeConfig.blockSizeHorizontal! * 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/dog_marly02.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? SizeConfig.blockSizeVertical! * 40
                            : 75,
                        width: SizeConfig.blockSizeHorizontal! * 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/dog_marly03.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
