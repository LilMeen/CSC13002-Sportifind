// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/auth/widgets/green_white_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/auth/role_screen.dart';

final _firebase = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _reenterPassword = '';
  
  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save(); 

    if (_reenterPassword != _enteredPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Re-entered password does not match!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try{
      final userCredential = await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'email': _enteredEmail,
        });

      Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleScreen()));

    }  catch (error){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Existing account with this email'),
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

          const SizedBox(height: 15),

          // RE-ENTER PASSWORD
          const SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Re-enter password",
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
            onSaved: (value) {
              _reenterPassword = value!;
            },
          ),

          const SizedBox(height: 25),
          GreenWhiteButton(
            text: "Create account",
            onTap: _submit,
            height: 50,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}