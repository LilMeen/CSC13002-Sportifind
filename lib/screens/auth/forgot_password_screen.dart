import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/auth/presentations/screens/sign_in_screen.dart';
import 'package:sportifind/features/auth/presentations/widgets/green_white_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _enteredEmail);
      showDialog(
        context: context,
        builder: (context) => AlertDialog (
          title: const Text('Password reset email sent!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(SignInScreen.route());
              },
              child: const Text('OK'),
            ),
          ],
        )
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override   
  Widget build (BuildContext context){
    return MaterialApp(
      home: Scaffold(
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
                    'Forgot Password',
                    style: SportifindTheme.display1,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: _form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // EMAIL
                              const SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Email",
                                    style: SportifindTheme.headline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  hintText: "example@gmail.com",
                                  hintStyle: SportifindTheme.greyTitle,
                                  filled: true,
                                  fillColor: Colors.white70,
                                  prefixIcon: const Icon(Icons.email),
                                ),
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              GreenWhiteButton(
                                text: "Reset password",
                                onTap: _submit,
                                height: 50,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
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
}