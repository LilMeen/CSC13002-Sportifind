import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/widgets/information_box.dart';

// Custom widget for displaying header and information box
class InformationBoxWithHeader extends StatelessWidget {
  const InformationBoxWithHeader({
    super.key,
    required this.headerText,
    required this.infoText,
    required this.boxHeight,
    required this.boxWidth,
    required this.prefixIcon,
  });

  final String headerText;
  final String infoText;
  final double boxHeight;
  final double boxWidth;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              headerText,
              style: GoogleFonts.lexend(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        InformationBox(
          boxHeight: boxHeight,
          boxWidth: boxWidth,
          text: infoText,
          prefixIcon: prefixIcon,
        ),
      ],
    );
  }
}