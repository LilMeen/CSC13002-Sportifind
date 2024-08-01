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
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.grey),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        children: [
          Image.asset(
            'lib/assets/google_logo.png',
            height: 24,
            width: 24,
          ),
          const Spacer(),
          const Text(
            'Sign in with Google',
            style: SportifindTheme.title,
          ),          
          const Spacer(),
        ],
      ),
    );
  }
}
