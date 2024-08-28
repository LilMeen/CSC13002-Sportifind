import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class LeftMessage extends StatelessWidget {
  const LeftMessage({
    super.key,
    required this.senderName,
    required this.receiverName,
  });

  final String senderName;
  final String receiverName;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$senderName has left ",
        style: SportifindTheme.smallSpanBlack,
        children: [
          TextSpan(
            text: receiverName,
            style: SportifindTheme.bigSpanBlack,
          ),
        ],
      ),
    );
  }
}
