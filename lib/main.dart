import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportifind/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sportifind/screens/player/team/screens/team_main_screen.dart';
import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';

Future <void> main() async{
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return const MaterialApp(
      home: TeamMainScreen(),
    );
  }
}
