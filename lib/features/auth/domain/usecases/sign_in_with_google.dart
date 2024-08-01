import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}