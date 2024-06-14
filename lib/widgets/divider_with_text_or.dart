import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DividerWithTextOR extends StatelessWidget {
  const DividerWithTextOR({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'OR',
            style: GoogleFonts.lexend(
        textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}