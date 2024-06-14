import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationBox extends StatelessWidget {
  const InformationBox(
      {super.key,
      required this.boxHeight,
      required this.boxWidth,
      required this.text,
      required this.prefixIcon,});

  final double boxHeight;
  final double boxWidth;
  final String text;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          obscureText: true,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            hintText: text,
            hintStyle: GoogleFonts.lexend(
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
            filled: true,
            fillColor: Colors.white70,
            prefixIcon: const Icon(Icons.lock),
          ),
        ),
      ),
    );
  }
}
