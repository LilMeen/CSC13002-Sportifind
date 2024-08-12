import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetAllStadiumOwner implements UseCase<List<StadiumOwnerEntity>, NoParams> {
  final ProfileRepository repository;

  GetAllStadiumOwner(this.repository);

  @override
  Future<Result<List<StadiumOwnerEntity>>> call(NoParams params) async {
    return await repository.getAllStadiumOwners();
  }
}