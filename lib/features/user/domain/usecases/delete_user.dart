import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class DeleteUser implements UseCase<void, DeleteUserParams> {
  final UserRepository userRepository;

  DeleteUser(this.userRepository);

  @override
  Future<Result<void>> call(DeleteUserParams params) async {
    return await userRepository.deleteUser(params.user);
  }
}

class DeleteUserParams {
  final UserEntity user;

  DeleteUserParams({required this.user});
}