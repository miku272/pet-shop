import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_styles.dart';

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
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return const Scaffold();
  }
}
