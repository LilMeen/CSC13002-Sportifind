import 'package:cloud_firestore/cloud_firestore.dart';

void initUser (String uid) async {
  final usersData = FirebaseFirestore.instance.collection('users');
  await usersData.doc(uid).set({
    'email': '',
    'role': '',
    'name': '',
    'dob': '',
    'city': '',
    'district': '',
    'address': '',
    'phone': '',
  });
}