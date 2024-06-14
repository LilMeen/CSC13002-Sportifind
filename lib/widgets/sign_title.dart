import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignTitle extends StatelessWidget {
  final String title;

  const SignTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.lexend(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }
}