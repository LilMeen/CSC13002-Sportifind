import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportifind/features/user/domain/entities/user.dart';

class GetCurrentProfile implements UseCase<UserEntity, NoParams> {
  final ProfileRepository repository;

  GetCurrentProfile(this.repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) async {
    return await repository.getCurrentProfile();
  }
}

