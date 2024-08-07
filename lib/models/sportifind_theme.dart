import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:google_fonts/google_fonts.dart';

class SportifindTheme {
  SportifindTheme._();

  static const Color smokeScreen = Color.fromARGB(255, 174, 174, 174);
  static const Color lead = Color.fromARGB(255, 33, 33, 33);
  static const Color whiteSmoke = Color.fromARGB(255, 245, 245, 245);
  static const Color whiteEdgar = Color.fromARGB(255, 237, 237, 237);

  // Color Hunt Palette
  static const Color shovelKnight = Color.fromARGB(255, 62, 194, 236);
  static const Color blueOyster = Color.fromARGB(255, 75, 112, 245);
  static const Color bluePurple = Color.fromARGB(255, 76, 59, 207);
  static const Color clearPurple = Color.fromARGB(255, 64, 46, 122);

  static const Color black = Color.fromARGB(255, 0, 0, 0);

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color.fromARGB(255, 242, 242, 242);
  static Color bluePurple2 = HexColor("4B70F5");
  static Color bluePurple1 = HexColor("3DC2EC");
  static Color bluePurple3 = HexColor("4C3BCF");
  static Color bluePurple4 = HexColor("402E7A");

  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const Color matchCard = Color.fromARGB(255, 217, 217, 217);

  static const TextTheme textTheme = TextTheme(
    titleSmall: display1,
    titleMedium: headline,
    titleLarge: title,
    displayMedium: subtitle,
    bodyLarge: body2,
    bodyMedium: body1,
    labelLarge: caption,
  );

  static TextStyle AppBarTittle1 = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 50,
    color: bluePurple,
  );

  static TextStyle AppBarTittle2 = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 36,
    color: bluePurple,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: white,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 0.4,
    height: 0.9,
    color: white,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle status = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: white,
  );

  static const TextStyle greyTitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: Colors.grey,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
