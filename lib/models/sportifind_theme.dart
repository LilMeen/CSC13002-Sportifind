import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:google_fonts/google_fonts.dart';

class SportifindTheme {
  SportifindTheme._();

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

  // static TextStyle normalTextSmokeScreen = GoogleFonts.lexend(
  //   fontWeight: FontWeight.normal,
  //   fontSize: 20,
  //   color: smokeScreen,
  // );

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
}
