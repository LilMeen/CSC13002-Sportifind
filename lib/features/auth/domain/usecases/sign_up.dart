import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';

class SignUp implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Result<void>> call(SignUpParams params) async {
    return await repository.signUpWithEmailPassword(
      params.email,
      params.password,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({
    required this.email,
    required this.password,
  });
}