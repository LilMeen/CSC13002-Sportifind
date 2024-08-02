import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/init/init_user.dart';


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
    await GoogleSignIn().signOut();
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.additionalUserInfo!.isNewUser) {
      initUser(userCredential.user!.uid.toString());
      FirebaseFirestore.instance
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

      initUser(userCredential.user!.uid);
      FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
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
      });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
    final role = snapshot['role'];
    return Result.success(null, message: role);
  }
}