import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportifind/core/models/result.dart';

class SignIn implements UseCase<void, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Result<void>> call(SignInParams params) async {
    return await repository.signInWithEmailPassword(
      params.email,
      params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
