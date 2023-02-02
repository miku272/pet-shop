import 'package:flutter/material.dart';

import '../app_styles.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String senderId;
  final String senderName;
  final bool sentByMe;

  const MessageTile({
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.sentByMe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
