import 'package:flutter/material.dart';
import 'package:sportifind/core/di/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportifind/features/auth/presentations/screens/splash_screen.dart';
import 'package:sportifind/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future <void> main() async{
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}  
 


/*void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDependencies();

  await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'admin@mail.com', password: '12345678');
  final StadiumRemoteDataSource stadiumRemoteDataSource = sl();
  final stadium = await stadiumRemoteDataSource.getStadiumById(id: 'uMzHuJX73aXYb1LGGMNt');
  
  final stadiumEntity = await stadium.toEntity();
}
*/