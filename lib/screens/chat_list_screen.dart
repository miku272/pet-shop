import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../app_styles.dart';

import '../widgets/custom_app_drawer.dart';
import '../widgets/drawer_icon_button.dart';
import '../widgets/main_loading.dart';
import '../widgets/chat_list_tile.dart';

import '../services/database_service.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chat-list-screen';

  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream? chats;

  getUSerData() async {
    final userData = await DatabaseService().getUserChats();

    setState(() {
      chats = userData;
    });
  }

  Widget chatList() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        if (snapshot.hasData) {
          if (snapshot.data['chats'].length != 0) {
            return ListView.builder(
              itemCount: snapshot.data['chats'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['chats'].length - index - 1;

                return ChatListTile(
                  chatId: snapshot.data['chats'][reverseIndex],
                );
              },
            );
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Lottie.asset(
                    'assets/loaders/lurking-cat.json',
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nothing here for now...',
                    style: sourceSansProSemiBold.copyWith(
                      fontSize: 18,
                      color: grey,
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Lottie.asset(
                'assets/loaders/lurking-cat.json',
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 20),
              Text(
                'Nothing here for now...',
                style: sourceSansProSemiBold.copyWith(
                  fontSize: 18,
                  color: grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getUSerData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      appBar: AppBar(
        leadingWidth: 80,
        leading: const DrawerIconButton(),
        title: Text(
          'Chats',
          style: sourceSansProBold.copyWith(
            fontSize: 23,
            color: grey,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                child: chats != null ? chatList() : const MainLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
