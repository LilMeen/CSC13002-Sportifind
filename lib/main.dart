import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/di/comp/auth_injection_container.dart';
import 'package:sportifind/core/di/injection_container.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/auth/domain/usecases/sign_in.dart';
import 'package:sportifind/features/auth/presentations/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_stadium_by_id.dart';
import 'package:sportifind/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

/* Future <void> main() async{
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
}  */

void main() async {
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
  print(stadiumEntity.name);
  print(stadiumEntity.phone);
  print(stadiumEntity.owner);
  print(stadiumEntity.location.name);
  print(stadiumEntity.location.address);
  print(stadiumEntity.location.fullAddress);
  print(stadiumEntity.location.latitude);
  print(stadiumEntity.location.longitude);
  for (var field in stadiumEntity.fields) {
    print(field.id);
    print(field.numberId);
    print(field.type);
    print(field.price);
    print(field.status);
  }
} 
