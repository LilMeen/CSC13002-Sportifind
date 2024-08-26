import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/features/user/domain/repositories/user_repository.dart';

class GetUser implements UseCase<UserEntity, GetUserParams> {
  final UserRepository userRepository;

  GetUser(this.userRepository);

  @override
  Future<Result<UserEntity>> call(GetUserParams params) async {
    return await userRepository.getUser(params.id);
  }
}

class GetUserParams {
  final String id;

  GetUserParams({required this.id});
}