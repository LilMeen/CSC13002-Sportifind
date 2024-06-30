import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class BookingExplanation extends StatelessWidget {
  const BookingExplanation(
      {super.key,
      required this.color,
      required this.text,
      this.explanationIconSize});

  final Color color;
  final String text;
  final double? explanationIconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: explanationIconSize ?? 16,
          width: explanationIconSize ?? 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text,
            style: SportifindTheme.status),
      ],
    );
  }
}
