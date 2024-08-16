import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_field_by_numberid.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class CreateMatch implements UseCase<void, CreateMatchParams> {
  final MatchRepository repository;
  CreateMatch(this.repository);

  @override
  Future<Result<void>> call(CreateMatchParams params) async {
    final selectedField = await UseCaseProvider.getUseCase<GetFieldByNumberid>().call(GetFieldByNumberidParams(
      stadium: params.stadium,
      numberId: params.fieldNumberId,
    )).then((value) => value.data!);

    MatchEntity match = MatchEntity(
      id: '',
      stadium: params.stadium,
      field: selectedField,
      date: params.date,
      start: params.start,
      end: params.end,
      playTime: params.playTime,
      team1: params.team1,
      team2: null,
    );
    return await repository.createMatch(match);
  }
}

class CreateMatchParams {
  final StadiumEntity stadium;
  final int fieldNumberId;
  final String date;
  final String start;
  final String end;
  final String playTime;
  final TeamEntity team1;

  CreateMatchParams({
    required this.stadium,
    required this.fieldNumberId,
    required this.date,
    required this.start,
    required this.end,
    required this.playTime,
    required this.team1,
  });
}