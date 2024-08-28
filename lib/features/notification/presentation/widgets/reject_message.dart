import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class RejectMessage extends StatelessWidget {
  const RejectMessage(
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
        text: "$receiverName ",
        style: SportifindTheme.bigSpanBlack,
        children: [
          TextSpan(
            text: forMatch == true
                ? "'s match invitation has been rejected by "
                : "'s team invitation has been rejected by ",
            style: SportifindTheme.smallSpanBlack,
          ),
          TextSpan(
            text: senderName,
            style: SportifindTheme.bigSpanBlack,
          ),
        ],
      ),
    );
  }
}
