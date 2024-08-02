import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportifind/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sportifind/core/models/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Result<void>> signInWithEmailPassword(String email, String password) async {
    return await remoteDataSource.signInWithEmailPassword(email, password);
  }

  @override
  Future<Result<void>> signUpWithEmailPassword(String email, String password) async {
    return await remoteDataSource.signUpWithEmailPassword(email, password);
  }

  @override
  Future<Result<void>> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<Result<void>> setRole(String role) async {
    return await remoteDataSource.setRole(role);
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
    return await remoteDataSource.setBasicInfo(
      name,
      dob,
      gender,
      city,
      district,
      address,
      phone,
    );
  }
}