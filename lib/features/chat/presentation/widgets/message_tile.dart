import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/chat/domain/entities/message_entity.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message});

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: message.sender.id == userId ? 0 : 24,
          right: message.sender.id == userId ? 24 : 0),
      alignment: message.sender.id == userId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: message.sender.id == userId
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: message.sender.id == userId
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: message.sender.id == userId
              ? const Color.fromARGB(255, 102, 155, 248)
              : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.sender.name.toUpperCase(),
              textAlign: TextAlign.start,
              style: SportifindTheme.featureTitleBlack
                  .copyWith(fontSize: 13.0, letterSpacing: -0.5),
            ),
            const SizedBox(height: 7.0),
            Text(
              message.message,
              textAlign: TextAlign.start,
              style: SportifindTheme.normalText
                  .copyWith(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
