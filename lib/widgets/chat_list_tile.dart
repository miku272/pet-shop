import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_shop/app_styles.dart';

import '../services/database_service.dart';

import '../screens/chat_screen.dart';

class ChatListTile extends StatefulWidget {
  final String chatId;

  const ChatListTile({required this.chatId, Key? key}) : super(key: key);

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  Stream? chatList;
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future getChatStream() async {
    final chatListData =
        await DatabaseService().getChatDataUsingUid(widget.chatId);

    setState(() {
      chatList = chatListData;
    });
  }

  @override
  void initState() {
    getChatStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        String recentMessage =
            snapshot.data['recentMessage'] ?? 'With ❤️ from pet shop';

        return ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: widget.chatId,
            );
          },
          leading: CircleAvatar(
            backgroundColor: boxShadowColor,
            radius: 25,
            child: Text(
              snapshot.data['senderId'] == currentUserId
                  ? snapshot.data['receiverName'][0]
                  : snapshot.data['senderName'][0],
              style: sourceSansProSemiBold.copyWith(
                fontSize: 25,
                color: black,
              ),
            ),
          ),
          title: Text(
            snapshot.data['senderId'] == currentUserId
                ? snapshot.data['receiverName']
                : snapshot.data['senderName'],
            style: sourceSansProSemiBold.copyWith(
              fontSize: 20,
              color: grey,
            ),
          ),
          subtitle: Text(
            snapshot.data['recentMessageSender'] == currentUserId
                ? 'You: $recentMessage'
                : recentMessage,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
