import 'package:sportifind/core/models/result.dart';

abstract interface class AuthRepository {
  Future<Result<void>> signInWithEmailPassword(String email, String password); 
  Future<Result<void>> signUpWithEmailPassword(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<void>> signInWithGoogle();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> setRole(String role);
  Future<Result<void>> setBasicInfo(String name, String dob, String gender, String city, String district, String address, String phone);
}