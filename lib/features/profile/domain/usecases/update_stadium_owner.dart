import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class UpdateStadiumOwner implements UseCase<void, UpdateStadiumOwnerParams> {
  UpdateStadiumOwner(this.repository);

  final ProfileRepository repository;

  @override
  Future<Result<void>> call(UpdateStadiumOwnerParams params) async {
    return await repository.updateStadiumOwner(params.stadiumOwner);
  }
}

class UpdateStadiumOwnerParams {
  final StadiumOwnerEntity stadiumOwner;

  UpdateStadiumOwnerParams({required this.stadiumOwner});
}