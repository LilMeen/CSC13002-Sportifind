import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sportifind/widgets/divider_with_text_or.dart';
import 'package:sportifind/widgets/green_white_button.dart';
import 'package:sportifind/widgets/profile_avatar.dart';
import 'package:sportifind/widgets/sign_in_with_google_button.dart';
import 'package:sportifind/widgets/information_box_with_header.dart';
import 'package:sportifind/widgets/sign_title.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: SportifindTheme.background,
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProfileAvatar(),
                  const SizedBox(height: 20),
                  const SignTitle(title: 'Sign in'),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const InformationBoxWithHeader(
                              headerText: "Email",
                              infoText: "example@gmail.com",
                              boxHeight: 50,
                              boxWidth: double.infinity,
                              prefixIcon: Icon(Icons.email),
                            ),
                            const SizedBox(height: 15),
                            const InformationBoxWithHeader(
                              headerText: "Password",
                              infoText: "At least 8 words",
                              boxHeight: 50,
                              boxWidth: double.infinity,
                              prefixIcon: Icon(Icons.lock),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value!;
                                          });
                                        },
                                        activeColor: const Color.fromARGB(
                                            255, 4, 203, 148),
                                      ),
                                    ),
                                    Text(
                                      'Remember me',
                                      style: GoogleFonts.lexend(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: GoogleFonts.lexend(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            GreenWhiteButton(
                              text: "Sign in",
                              onTap: () {},
                              height: 50,
                              width: double.infinity,
                            ),
                          ],
                        ),
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
                        onPressed: () {},
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xFF00C6AE),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const DividerWithTextOR(),
                  const SizedBox(height: 15),
                  SignInWithGoogleButton(onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
