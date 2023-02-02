import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Container(
      padding: EdgeInsets.only(
        top: 4,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30, bottom: 10)
            : const EdgeInsets.only(right: 30, bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: paddingHorizontal * 0.5,
          vertical: paddingHorizontal * 0.3,
        ),
        decoration: BoxDecoration(
          color: sentByMe ? lightOrange : Colors.grey[200],
          borderRadius: sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              currentUserId == senderId ? 'You' : senderName,
              textAlign: TextAlign.center,
              style: sourceSansProSemiBold.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: sourceSansProRegular.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
