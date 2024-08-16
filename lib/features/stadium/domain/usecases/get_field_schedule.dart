import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetFieldSchedule implements UseCase<List<MatchEntity>, GetFieldScheduleParams> {
  final StadiumRepository repository;

  GetFieldSchedule(this.repository);

  @override
  Future<Result<List<MatchEntity>>> call(GetFieldScheduleParams params) async {
    return await repository.getFieldScedule(params.field, params.date);
  }
}

class GetFieldScheduleParams {
  final FieldEntity field;
  final String date;

  GetFieldScheduleParams({
    required this.field,
    required this.date,
  });
}