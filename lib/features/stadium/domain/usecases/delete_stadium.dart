import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class DeleteStadium implements UseCase<void, DeleteStadiumParams> {
  final StadiumRepository repository;

  DeleteStadium(this.repository);

  @override
  Future<Result<void>> call(DeleteStadiumParams params) async {
    return await repository.deleteStadium(params.id);
  }
}

class DeleteStadiumParams {
  final String id;

  DeleteStadiumParams(this.id);
}