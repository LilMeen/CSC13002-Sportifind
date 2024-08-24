import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class UpdateFieldStatus implements UseCase<void, UpdateFieldStatusParams> {
  final StadiumRepository repository;

  UpdateFieldStatus(this.repository);

  @override
  Future<Result<void>> call(UpdateFieldStatusParams params) async {
    return await repository.updateField(params.stadium);
  }
}

class UpdateFieldStatusParams {
  final StadiumEntity stadium;

  UpdateFieldStatusParams(this.stadium);
}