/* import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:sportifind/features/auth/presentations/widgets/green_white_button.dart';
import 'package:sportifind/features/auth/presentations/widgets/auth_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static route () =>
    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override   
  Widget build (BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password',
                    style: SportifindTheme.sportifindAppBarForFeature,
                    textAlign: TextAlign.left,        
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _form,
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
                          const SizedBox(height: 20),
                          GreenWhiteButton(
                            text: "Reset password",
                            onTap: () async{
                              if (_form.currentState!.validate()) {
                                await AuthBloc(context).forgotPassword(emailController.text);
                              }
                            },
                            height: 50,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:sportifind/features/auth/presentations/bloc/auth_bloc.dart';
import 'package:sportifind/features/auth/presentations/widgets/auth_field.dart';
import 'package:sportifind/features/auth/presentations/widgets/green_white_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const forgotPasswordText = 
      'Enter the email address with your account and we will send an email with confirmation to reset your password.';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Forgot password',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  forgotPasswordText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 20),
                GreenWhiteButton(
                  text: "Send",
                  onTap: () async{
                    if (_form.currentState!.validate()) {
                      await AuthBloc(context).forgotPassword(emailController.text);
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
    );
  }
}