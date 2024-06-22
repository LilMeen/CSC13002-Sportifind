import 'package:flutter/material.dart';
import 'package:sportifind/screens/auth/widgets/role_button.dart';

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
        child: const Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('lib/assets/logo/logo.png'),
              height: 200,
            ),
            SizedBox(height: 100),
            RoleButton('I am a Player'),
            SizedBox(height: 30),
            RoleButton('I am a Stadium owner'),
          ]
        )

      )
    );
  }
}

