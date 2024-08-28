import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class KickMessage extends StatelessWidget {
  const KickMessage({
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
        text: "$receiverName has been kicked by ",
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
