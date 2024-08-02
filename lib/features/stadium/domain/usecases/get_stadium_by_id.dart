import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetStadiumById implements UseCase<Stadium, GetStadiumByIdParams> {
  final StadiumRepository repository;
  GetStadiumById(this.repository);

  @override
  Future<Result<Stadium>> call(GetStadiumByIdParams params) async {
    return repository.getStadiumById(
      id: params.id,
    );
  }
}

class GetStadiumByIdParams {
  final String id;

  GetStadiumByIdParams({
    required this.id,
  });
}