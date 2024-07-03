import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> deleteUser(String email, String password, context) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
  String adminEmail = snapshot['email'];
  String adminPassword = snapshot['password'];

  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).delete();
  await userCredential.user!.delete();

  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: adminEmail,
    password: adminPassword,
  );
}