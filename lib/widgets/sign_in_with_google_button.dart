import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            'lib/assets/images/google_logo.png',
            height: 24,
            width: 24,
          ),
          const Spacer(),
          Text(
            'Sign in with Google',
            style: GoogleFonts.lexend(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
