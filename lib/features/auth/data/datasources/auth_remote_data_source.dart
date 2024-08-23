import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/location_util.dart';


abstract interface class AuthRemoteDataSource {
  Future<Result<void>> signInWithEmailPassword(String email, String password); 
  Future<Result<void>> signInWithGoogle();
  Future<Result<void>> signUpWithEmailPassword(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<void>> forgotPassword(String email);

  Future<Result<void>> setRole(String role);
  Future<Result<void>> setBasicInfo(
    String name,
    String dob,
    String gender,
    String city,
    String district,
    String address,
    String phone,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<void>> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get(); 
          
      if (!snapshot.exists) {
        return Result.failure("Your account is banned.");
      }
      final String role = snapshot['role'];
      return Result.success(null, message: role);
    } catch (error) {
      return Result.failure("Incorrect email or password.");
    }
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.additionalUserInfo!.isNewUser) {
      _initUser(userCredential.user!.uid.toString());
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'email': userCredential.user!.email,
        });
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .get(); 
    final String role = snapshot['role'];
    return Result.success(null, message: role);
  }

  @override
  Future<Result<void>> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _initUser(userCredential.user!.uid);
      await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .update({
          'email': email,
        });
      return Result.success(null);

    } catch (error) {
      return Result.failure("Existing account with this email.");
    }
  }

  @override
  Future<Result<void>> signOut() async {
    await _firebaseAuth.signOut();
    return Result.success(null);
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return Result.success(null);
  }

    @override
  Future<Result<void>> setRole(String role) async {
    await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'role': role,
      });
    return Result.success(null);
  }

  @override
  Future<Result<void>> setBasicInfo(
    String name,
    String dob,
    String gender,
    String city,
    String district,
    String address,
    String phone,
  ) async {
    Location location = await findLatAndLngFull(address, district, city);

    final ByteData byteData = await rootBundle.load('lib/assets/no_avatar.png');
    final Uint8List bytes = byteData.buffer.asUint8List();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(userId)
        .child('avatar')
        .child('avatar.jpg');

    final uploadTask = storageRef.putData(bytes);
    await uploadTask;

    final imageUrl = await storageRef.getDownloadURL();
    await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'name': name,
        'phone': phone,
        'dob': dob,
        'address': address,
        'gender': gender,
        'city': city,
        'district': district,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'avatarImage': imageUrl,
      });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
    final role = snapshot['role'];
    return Result.success(null, message: role);
  }


  void _initUser (String uid) async {
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
      'avatarImage': '',
      'longtiude': 0.0,
      'latitude': 0.0,
    });
  }
}

