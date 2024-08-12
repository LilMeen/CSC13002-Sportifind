import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetAllStadiums implements UseCase<List<StadiumEntity>, NoParams> {
  GetAllStadiums(this.repository);

  final StadiumRepository repository;

  @override
  Future<Result<List<StadiumEntity>>> call(NoParams params) async {
    return await repository.getAllStadiums();
  }
}