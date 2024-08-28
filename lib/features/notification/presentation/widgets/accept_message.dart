import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class AcceptMessage extends StatelessWidget {
  const AcceptMessage(
      {super.key,
      required this.senderName,
      required this.receiverName,
      required this.forMatch});

  final String senderName;
  final String receiverName;
  final bool forMatch;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "$senderName ",
        style: SportifindTheme.bigSpanBlack,
        children: [
          TextSpan(
            text: "has accepted ",
            style: SportifindTheme.smallSpanBlack,
          ),
          TextSpan(
            text: "$receiverName's ",
            style: SportifindTheme.bigSpanBlack,
          ),
          TextSpan(
            text: forMatch == true ? "match invitation" : "team invitation",
            style: SportifindTheme.smallSpanBlack,
          ),
        ],
      ),
    );
  }
}
