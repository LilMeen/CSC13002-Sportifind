import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class GetMatchByField implements UseCase<List<MatchEntity>, GetMatchByFieldParams> {
  final MatchRepository matchRepository;

  GetMatchByField(this.matchRepository);

  @override
  Future<Result<List<MatchEntity>>> call(GetMatchByFieldParams params) {
    return matchRepository.getMatchesByField(params.fieldId);
  }
}

class GetMatchByFieldParams {
  final String fieldId;

  GetMatchByFieldParams({required this.fieldId});
}