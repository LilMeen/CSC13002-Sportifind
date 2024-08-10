import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/auth/google_signin.dart';
import 'package:sportifind/screens/auth/sign_up_screen.dart';
import 'package:sportifind/screens/auth/signin.dart';

import 'package:sportifind/screens/auth/widgets/sign_in_with_google_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: SportifindTheme.whiteSmoke,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logo/logo.png',
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign in',
                    style: SportifindTheme.featureTitleBlack,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.white,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: SignIn(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: SportifindTheme.featureTitleWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: SportifindTheme.normalTextWhite,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: SportifindTheme.tinge,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SignInWithGoogleButton(
                      onPressed: () => signInwithGoogle(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
