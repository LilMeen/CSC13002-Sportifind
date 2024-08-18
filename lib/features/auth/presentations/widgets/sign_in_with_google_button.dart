import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignInWithGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.grey),
        ),
        minimumSize: const Size(double.infinity, 55),
      ),
      child: Row(
        children: [
          Image.asset(
            'lib/assets/google_logo.png',
            height: 30,
            width: 30,
          ),
          const Spacer(),
          Text(
            'Sign in with Google',
            style: SportifindTheme.normalTextBlackW500,
          ),          
          const Spacer(),
        ],
      ),
    );
  }
}
