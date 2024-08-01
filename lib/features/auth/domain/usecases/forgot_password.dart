import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportifind/core/models/result.dart';

class ForgotPassword implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Result<void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({
    required this.email,
  });
}