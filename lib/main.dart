import 'package:flutter/material.dart';
import 'package:sportifind/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportifind/firebase_options.dart';

Future <void> main() async{
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
      home:  SplashScreen(),
    );
  }
}
