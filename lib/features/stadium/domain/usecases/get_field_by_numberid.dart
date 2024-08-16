import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetFieldByNumberid implements UseCase<FieldEntity, GetFieldByNumberidParams> {
  final StadiumRepository repository;

  GetFieldByNumberid(this.repository);

  @override
  Future<Result<FieldEntity>> call(GetFieldByNumberidParams params) async {
    return await repository.getFieldByNumberId(params.stadium, params.numberId);
  }
}

class GetFieldByNumberidParams {
  final StadiumEntity stadium;
  final int numberId;

  GetFieldByNumberidParams({
    required this.stadium,
    required this.numberId,
  });
}