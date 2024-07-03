import 'package:sportifind/screens/player/match/widgets/common_card.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  const BookingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: CommonCard(child: Icon(Icons.book_online, size: 256)),
        ),
        SizedBox(height: 16),
        Text("Here comes your fancy loading"),
      ],
    );
  }
}
