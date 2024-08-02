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
      backgroundColor: SportifindTheme.background,
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
                const Text(
                  'Sign in',
                  style: SportifindTheme.display1,
                ),
                const SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: SportifindTheme.nearlyWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const SizedBox(height: 15),
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
                            const SizedBox(height: 7),
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
                                        activeColor: const Color.fromARGB(
                                            255, 4, 203, 148),
                                      ),
                                    ),
                                    const Text(
                                      'Remember me',
                                      style: SportifindTheme.body2,
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(ForgotPasswordScreen.route());
                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: SportifindTheme.body2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            GreenWhiteButton(
                              text: "Sign in",
                              onTap: () async {
                                if (formKey.currentState!.validate()) {                                 
                                  AuthBloc(context).signIn(
                                    emailController.text, 
                                    passwordController.text,
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
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(SignUpScreen.route());
                      },
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
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('OR', style: SportifindTheme.greyTitle),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white,
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
    );
  }
}
