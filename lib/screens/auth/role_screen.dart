import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/screens/auth/basic_information.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen ({super.key});

  @override 
  State<RoleScreen> createState(){
    return _RoleScreenState();
  }
}

class _RoleScreenState extends State<RoleScreen> {
  @override  
  Widget build (context){
    return Scaffold(
      body: Container( 
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(33, 33, 33, 1),
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('lib/assets/logo/logo.png'),
              height: 100,
            ),
            const SizedBox(height: 200),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: (){
                  FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                      'role': 'player',
                    });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicInformationScreen()),
                  );
                },
                style:  ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'I am a Player',
                  textAlign: TextAlign.center,
                  style: SportifindTheme.headline,
                )
              ),
            ),          
            const SizedBox(height: 30),
            SizedBox(
              height: 100,
              width: 300,
              child: ElevatedButton(
                onPressed: (){
                  FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                      'role': 'stadium_owner',
                    });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicInformationScreen()),
                  );
                },
                style:  ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: const Text(
                  'I am a Stadium owner',
                  textAlign: TextAlign.center,
                  style: SportifindTheme.headline,
                )
              ),
            ),          
          ]
        )
      )
    );
  }
}

