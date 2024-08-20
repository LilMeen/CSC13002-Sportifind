import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportifind/adapter/hex_color.dart';

class SportifindTheme {
  SportifindTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color.fromARGB(255, 242, 242, 242);
  static Color bluePurple2 = HexColor("4B70F5");
  static Color bluePurple1 = HexColor("3DC2EC");
  static Color bluePurple3 = HexColor("4C3BCF");
  static Color bluePurple4 = HexColor("402E7A");

  static const Color nearlyBlack = Color(0xFF213333);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    titleSmall: display1,
    titleMedium: headline,
    titleLarge: title,
    displayMedium: subtitle,
    bodyLarge: body2,
    bodyMedium: body1,
    labelLarge: caption,
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

  static const Color smokeScreen = Color.fromARGB(255, 174, 174, 174);
  static const Color lead = Color.fromARGB(255, 33, 33, 33);
  static const Color whiteSmoke = Color.fromARGB(255, 245, 245, 245);
  static const Color whiteEdgar = Color.fromARGB(255, 237, 237, 237);
  static const Color tinge = Color.fromARGB(255, 230, 230, 230);

  // Color Hunt Palette
  static Color shovelKnight = HexColor("3DC2EC");
  static Color blueOyster = HexColor("4B70F5");
  static Color bluePurple = HexColor("4C3BCF");
  static Color clearPurple = HexColor("402E7A");

  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);
  static const Color matchCard = Color.fromARGB(255, 217, 217, 217);

  ////////////////////////////////////////////////////////////////////
  static const Color backgroundColor = Colors.white;
  ////////////////////////////////////////////////////////////////////

  // Match Management text styles
  static TextStyle matchMonthDisplay = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 40,
    color: bluePurple,
  );

  static TextStyle matchVS = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 40,
    color: Colors.white,
  );

  static TextStyle matchDateDisplay = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: bluePurple,
  );

  static TextStyle matchCardItem = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle teamItem = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle memberItem = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: Colors.black,
  );

  static TextStyle yearOld = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.black,
  );

  static TextStyle matchTeamInfo = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: lead,
  );

  static TextStyle viewTeamDetails = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: bluePurple,
  );

  static TextStyle viewProfileDetails = GoogleFonts.lexend(
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: bluePurple,
  );

  static TextStyle teamDisplay = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: bluePurple,
  );

  static TextStyle dropDownDisplay = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 30,
    color: Colors.white,
  );

  static TextStyle bookingIndex = GoogleFonts.lexend(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: Colors.black,
  );

  // app bar text style
  static TextStyle sportifindAppBar = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 48,
    color: bluePurple,
  );

  static TextStyle sportifindAppBarForFeature = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 36,
    color: lead,
  );

  // ex: create team, Profile
  static TextStyle featureTitlePurple = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 30,
    color: bluePurple,
  );

  // ex: Basic information
  static TextStyle featureTitleBlack = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 30,
    color: Colors.black,
  );

  static TextStyle featureTitleWhite = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 30,
    color: Colors.white,
  );

  static TextStyle textBluePurple = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 25,
    color: bluePurple,
  );

  static TextStyle textWhite = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 25,
    color: Colors.white,
  );

  static TextStyle textBlack = GoogleFonts.lexend(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.black,
  );

  static TextStyle auth = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 48,
    color: Colors.white,
  );

  // just adjust yourself to fit
  static TextStyle normalText = GoogleFonts.lexend(
    fontWeight: FontWeight.normal,
  );

  // static TextStyle normalTextBlack = GoogleFonts.lexend(
  //   fontWeight: FontWeight.normal,
  //   fontSize: 20,
  //   color: Colors.black,
  // );

  // static TextStyle normalTextWhite = GoogleFonts.lexend(
  //   fontWeight: FontWeight.normal,
  //   fontSize: 20,
  //   color: Colors.white,
  // );

  static TextStyle hintTextSmokeScreen = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: smokeScreen,
  );

  static TextStyle normalTextWhiteW400 = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: Colors.white,
  );

  static TextStyle normalTextBlackW500 = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.black,
  );

  static TextStyle normalTextBlackW400 = GoogleFonts.lexend(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.black,
  );

  static TextStyle normalTextBlackW700 = GoogleFonts.lexend(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: Colors.black,
  );

  static TextStyle smallSpan = GoogleFonts.inter(
      fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white);

  static TextStyle bigSpan = GoogleFonts.inter(
      fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white);

  static TextStyle normalTextBlack = GoogleFonts.lexend(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: Colors.black,
  );

  static TextStyle normalTextWhite = GoogleFonts.lexend(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle normalTextSmokeScreen = GoogleFonts.lexend(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: smokeScreen,
  );

  static TextStyle roleInformationPicked = GoogleFonts.racingSansOne(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: bluePurple,
  );

  static TextStyle roleInformationUnpicked = GoogleFonts.racingSansOne(
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: grey,
  );

  ////////////new
  static TextStyle bodyTitle = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: bluePurple,
  );

  static TextStyle body = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.black,
  );

  static TextStyle appBar = GoogleFonts.lexend(
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: const Color.fromRGBO(49, 58, 68, 1),
  );

  //Stadium text style
  static TextStyle stadiumCard = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle dropdownGreen = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.green,
  );
  static TextStyle dropdownGreenBold = GoogleFonts.lexend(
    fontWeight: FontWeight.w900,
    fontSize: 14,
    color: Colors.green,
  );

  static TextStyle dropdownRed = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.red,
  );

  static TextStyle dropdownRedBold = GoogleFonts.lexend(
    fontWeight: FontWeight.w900,
    fontSize: 14,
    color: Colors.red,
  );

  static TextStyle sportifindFeatureAppBarBluePurple = GoogleFonts.rowdies(
    fontWeight: FontWeight.normal,
    fontSize: 30,
    color: bluePurple,
  );

  static TextStyle warningText = GoogleFonts.lexend(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Colors.red,
  );
}
