import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class GetMatch implements UseCase<MatchEntity, GetMatchParams> {
  final MatchRepository repository;

  GetMatch(this.repository);

  @override
  Future<Result<MatchEntity>> call(GetMatchParams params) async {
    return await repository.getMatch(params.matchId);
  }
}

class GetMatchParams {
  final String matchId;

  GetMatchParams({required this.matchId});
}