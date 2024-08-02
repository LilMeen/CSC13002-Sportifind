import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetStadiumByOwner implements UseCase<List<Stadium>, GetStadiumByOwnerParams> {
  final StadiumRepository repository;
  GetStadiumByOwner(this.repository);

  @override
  Future<Result<List<Stadium>>> call(GetStadiumByOwnerParams params) async {
    return repository.getStadiumsByOwner(
      owner: params.owner,
    );
  }
}

class GetStadiumByOwnerParams {
  final String owner;

  GetStadiumByOwnerParams({
    required this.owner,
  });
}