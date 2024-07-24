import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/screens/auth/role_screen.dart';
import 'package:sportifind/screens/player/player_home_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium_owner_home_screen.dart';

signInwithGoogle(context) async {
  await GoogleSignIn().signOut();
  final googleSignIn = GoogleSignIn();
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  if (userCredential.additionalUserInfo!.isNewUser) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .set({
        'email': userCredential.user!.email,
      });
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleScreen()));
  }
  else {
    final userRole = await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          return documentSnapshot.get('role');
        }
      }); 
    if (userRole == 'player') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayerHomeScreen()));
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StadiumOwnerHomeScreen()));
    }
  }
}



final _firebase = FirebaseAuth.instance;

class SigninWihGoogle extends StatefulWidget {
  const SigninWihGoogle({super.key});

  @override
  State<SigninWihGoogle> createState() {
    return _SignInWithGoogleState();
  }
}

class _SignInWithGoogleState extends State<SigninWihGoogle> {

  
  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 10);
  }
}