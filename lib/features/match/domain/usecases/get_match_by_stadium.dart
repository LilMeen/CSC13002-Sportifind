import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class GetMatchByStadium implements UseCase<List<MatchEntity>, GetMatchByStadiumParams> {
  final MatchRepository matchRepository;

  GetMatchByStadium(this.matchRepository);

  @override
  Future<Result<List<MatchEntity>>> call(GetMatchByStadiumParams params) {
    return matchRepository.getMatchesByStadium(params.stadiumId);
  }
}

class GetMatchByStadiumParams {
  final String stadiumId;

  GetMatchByStadiumParams({required this.stadiumId});
}