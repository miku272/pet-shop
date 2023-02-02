import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../widgets/main_loading.dart';

import '../services/database_service.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    String chatId = ModalRoute.of(context)!.settings.arguments as String;

    return ChatScreenWid(chatId: chatId);
  }
}

class ChatScreenWid extends StatefulWidget {
  final String chatId;

  const ChatScreenWid({
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreenWid> createState() => _ChatScreenWidState();
}

class _ChatScreenWidState extends State<ChatScreenWid> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  var appBarTitle = '';

  Future getappBarTitle() async {
    final chatData =
        await DatabaseService().getStaticChatDataUsingUid(widget.chatId);

    if (currentUser == chatData.data()!['senderId']) {
      setState(() {
        appBarTitle = chatData.data()!['receiverName'];
      });
    } else {
      setState(() {
        appBarTitle = chatData.data()!['senderName'];
      });
    }
  }

  @override
  void initState() {
    getappBarTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: boxShadowColor,
        title: Text(
          appBarTitle,
          style: sourceSansProSemiBold.copyWith(
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseService().getStaticChatDataUsingUid(
          widget.chatId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: MainLoading(),
            );
          }

          if (snapshot.hasData) {
            return Center(
              child: Text(
                currentUser == snapshot.data!['senderId']
                    ? snapshot.data!['receiverName']
                    : snapshot.data!['senderName'],
              ),
            );
          }

          return Center(
            child: Text(
              'Something went wrong...',
              style: sourceSansProRegular.copyWith(
                fontSize: 18,
                color: grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
