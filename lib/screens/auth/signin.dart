// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/auth/widgets/green_white_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/screens/home_screen.dart';
import 'package:sportifind/screens/admin/admin_home_screen.dart';

final _firebase = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final _form = GlobalKey<FormState>();
  
  bool _rememberMe = false;
  var _enteredEmail = '';
  var _enteredPassword = '';
  
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save(); 
    
    try{
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      if (snapshot['role'] == 'admin'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
      }
      else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SportifindHomeScreen()));
      }
    }  catch (error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect email or password.'),
          backgroundColor: Colors.red,
        ),
      ); 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
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
              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              _enteredEmail = value!;
            },
          ),

          const SizedBox(height: 15),

          // PASSWORD
          const SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Password",
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
              hintText: "At least 8 words",
              hintStyle: SportifindTheme.greyTitle,
              filled: true,
              fillColor: Colors.white70,
              prefixIcon: const Icon(Icons.lock), 
            ),
            obscureText: true, 
            validator: (value) {
              if (value == null || value.length < 8) {
                return 'Password must be at least 8 characters!';
              }
              return null;
            },
            onSaved: (value) {
              _enteredPassword = value!;
            },
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
                  const Text(
                    'Remember me',
                    style: SportifindTheme.body2,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
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
            onTap: _submit,
            height: 50,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}