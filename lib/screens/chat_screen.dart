import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

import '../widgets/main_loading.dart';
import '../widgets/message_tile.dart';

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
  Stream? chat;
  QuerySnapshot? userData;
  final TextEditingController _controller = TextEditingController();

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

  getChats() {
    setState(() {
      chat = DatabaseService().getChats(widget.chatId);
    });
  }

  getUserData() async {
    final data = await DatabaseService().getUserDataUsingUid(
      FirebaseAuth.instance.currentUser!.uid,
    );

    userData = data;
  }

  _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        'message': _controller.text,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'senderName': userData!.docs[0]['firstName'],
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.chatId, chatMessage);

      setState(() {
        _controller.clear();
      });
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chat,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: MainLoading(),
          );
        }

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    senderId: snapshot.data.docs[index]['senderId'],
                    senderName: snapshot.data.docs[index]['senderName'],
                    sentByMe: snapshot.data.docs[index]['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid,
                  );
                },
              )
            : Center(
                child: Text(
                  'No messages...',
                  style: sourceSansProSemiBold.copyWith(
                    fontSize: 20,
                    color: lightGrey,
                  ),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    getappBarTitle();
    getChats();
    getUserData();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[300],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: sourceSansProSemiBold,
                        decoration: InputDecoration(
                          hintText: 'Your message...',
                          hintStyle: sourceSansProSemiBold,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: boxShadowColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send_rounded,
                            color: grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
