import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Color(0xFF00C6AE),
      child: ClipOval(
        child: Image(
          image: AssetImage('lib/assets/logo.png'),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}