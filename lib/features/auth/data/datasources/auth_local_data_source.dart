import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/core/models/result.dart';

abstract interface class AuthLocalDataSource {
  
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

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
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