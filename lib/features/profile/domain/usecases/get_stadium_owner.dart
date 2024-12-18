import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/profile/domain/repositories/profile_repository.dart';

class GetStadiumOwner implements UseCase<StadiumOwnerEntity, GetStadiumOwnerParams> {
  GetStadiumOwner(this.repository);

  final ProfileRepository repository;

  @override
  Future<Result<StadiumOwnerEntity>> call(GetStadiumOwnerParams params) async {
    return await repository.getStadiumOwner(params.id);
  }
}

class GetStadiumOwnerParams{
  final String id;

  GetStadiumOwnerParams({required this.id});
}