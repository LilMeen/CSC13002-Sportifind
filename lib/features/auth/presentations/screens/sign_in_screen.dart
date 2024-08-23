// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:sportifind/features/auth/presentations/screens/forgot_password_screen.dart';
import 'package:sportifind/features/auth/presentations/widgets/auth_field.dart';
import 'package:sportifind/features/auth/presentations/widgets/green_white_button.dart';
import 'package:sportifind/features/auth/presentations/widgets/sign_in_with_google_button.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignInScreen());

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/loginBackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Sign in',
                      style: SportifindTheme.auth,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 405,
                      color: SportifindTheme.nearlyWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AuthField(
                                label: 'Email',
                                hintText: 'example@mail.com',
                                icon: const Icon(Icons.email),
                                controller: emailController,
                                obscureText: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Invalid email.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              AuthField(
                                label: 'Password',
                                hintText: 'At least 8 words',
                                icon: const Icon(Icons.lock),
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 8) {
                                    return 'Password must be at least 8 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 13),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          activeColor:
                                              SportifindTheme.bluePurple,
                                        ),
                                      ),
                                      Text(
                                        'Remember me',
                                        style:
                                            SportifindTheme.normalTextBlackW400,
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(ForgotPasswordScreen.route());
                                    },
                                    child: Text(
                                      'Forgot Password',
                                      style:
                                          SportifindTheme.normalTextBlackW700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),
                              GreenWhiteButton(
                                text: "Sign in",
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    AuthBloc(context).signIn(
                                      emailController.text,
                                      passwordController.text,
                                      rememberMe: _rememberMe,
                                    );
                                  }
                                },
                                height: 50,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: SportifindTheme.smallSpan,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(SignUpScreen.route());
                        },
                        child: Text(
                          'Sign up',
                          style: SportifindTheme.bigSpan,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: SportifindTheme.tinge,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('OR', style: SportifindTheme.normalTextWhiteW400),
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
                    onPressed: () {
                      AuthBloc(context).signInWithGoogle();
                    },
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
