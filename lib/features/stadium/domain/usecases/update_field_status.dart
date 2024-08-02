import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class UpdateFieldStatus implements UseCase<void, UpdateFieldStatusParams> {
  StadiumRepository repository;
  UpdateFieldStatus(this.repository);

  @override
  Future<Result<void>> call(UpdateFieldStatusParams params) async {
    return await repository.updateFieldStatus(
      stadiumId: params.stadiumId,
      fieldId: params.fieldId,
      status: params.status,
    );
  }
}

class UpdateFieldStatusParams {
  final String stadiumId;
  final String fieldId;
  final bool status;

  UpdateFieldStatusParams({
    required this.stadiumId,
    required this.fieldId,
    required this.status,
  });
}