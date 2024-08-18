import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class GreenWhiteButton extends StatelessWidget {
  const GreenWhiteButton(
      {required this.text,
      required this.onTap,
      super.key,
      required this.height,
      required this.width});

  final String text;
  final void Function() onTap;
  final double height;
  final double width;

  @override
  Widget build(context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: SportifindTheme.bluePurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        shadowColor: Colors.black,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lexend(
              textStyle: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
