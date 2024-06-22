import 'package:flutter/material.dart';

class RoleButton extends StatelessWidget {  
  const RoleButton(this.roleText ,{super.key});

  final String roleText;

  @override  
  Widget build(context) {
    return SizedBox(
      height: 100,
      width: 300,
      child: ElevatedButton(
        onPressed: (){},
        style:  ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 40,
          ),
        ),
        child: Text(
          roleText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color:Color.fromRGBO(33, 33, 33, 1),
          )
        )
      ),
    );
  }
}