import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_in_screen.dart';
import 'package:sportifind/features/auth/presentations/widgets/auth_field.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:sportifind/features/auth/presentations/widgets/green_white_button.dart';

class SignUpScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignUpScreen());
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reenterPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


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
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: formKey,
                          child: Column(
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
                              const SizedBox(height: 15),
                              AuthField(
                                label: 'Re-enter password',
                                hintText: 'At least 8 words',
                                icon: const Icon(Icons.lock),
                                controller: reenterPasswordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 8) {
                                    return 'Password must be at least 8 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              GreenWhiteButton(
                                text: "Sign up",
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {                                 
                                    AuthBloc(context).signUp(
                                      emailController.text, 
                                      passwordController.text,
                                      reenterPasswordController.text,
                                    );
                                  }
                                },
                                height: 50,
                                width: double.infinity,
                              ),
                            ],
                          ), 
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already has an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(SignInScreen.route());
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Color(0xFF00C6AE),
                          ),
                        ),
                      ),
                    ],
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
