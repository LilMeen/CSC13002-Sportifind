import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetStadiumsByOwner implements UseCase<List<StadiumEntity>, GetStadiumsByOwnerParams> {
  GetStadiumsByOwner(this.repository);

  final StadiumRepository repository;

  @override
  Future<Result<List<StadiumEntity>>> call(GetStadiumsByOwnerParams params) async {
    return await repository.getStadiumsByOwner(params.ownerId);
  }
}

class GetStadiumsByOwnerParams{
  final String ownerId;

  GetStadiumsByOwnerParams({required this.ownerId});
}