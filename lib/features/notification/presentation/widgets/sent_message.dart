import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class SentMessage extends StatelessWidget {
  const SentMessage({
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
        text: "$senderName's ",
        style: SportifindTheme.bigSpanBlack,
        children: [
          TextSpan(
            text: "invitation has been sent to ",
            style: SportifindTheme.smallSpanBlack,
          ),
          TextSpan(
            text: receiverName,
            style: SportifindTheme.bigSpanBlack,
          ),
        ],
      ),
    );
  }
}
