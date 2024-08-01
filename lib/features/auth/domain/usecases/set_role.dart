import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/auth/domain/repositories/auth_repository.dart';

class SetRole implements UseCase<void, SetRoleParams> {
  final AuthRepository repository;

  SetRole(this.repository);

  @override
  Future<Result<void>> call(SetRoleParams params) async {
    return await repository.setRole(params.role);
  }
}

class SetRoleParams {
  final String role;

  SetRoleParams({
    required this.role,
  });
}