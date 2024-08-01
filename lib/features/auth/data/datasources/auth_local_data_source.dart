import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _usersData = FirebaseFirestore.instance.collection('users');

  @override
  Future<Result<void>> setRole(String role) async {
    await _usersData.doc().update({
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
    await _usersData.doc().update({
      'name': name,
      'dob': dob,
      'gender': gender,
      'city': city,
      'district': district,
      'address': address,
      'phone': phone,
    });
    return Result.success(null);
  }
}