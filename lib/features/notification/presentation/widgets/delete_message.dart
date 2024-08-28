import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class DeleteMessage extends StatelessWidget {
  const DeleteMessage(
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
        text: forMatch == true
            ? "Your match has been deleted by "
            : "Your team has been deleted by ",
        style: SportifindTheme.smallSpanBlack,
        children: [
          TextSpan(
            text: senderName,
            style: SportifindTheme.bigSpanBlack,
          ),
        ],
      ),
    );
  }
}
