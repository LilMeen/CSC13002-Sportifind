import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/signup.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: SportifindTheme.background,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'lib/assets/logo/logo.png',
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sign up',
                    style: SportifindTheme.display1,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: SportifindTheme.nearlyWhite,
                      child: const  Padding(
                        padding: EdgeInsets.all(15.0),
                        //child: SignUp(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Already has an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: ' Sign in',
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 203, 148),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
