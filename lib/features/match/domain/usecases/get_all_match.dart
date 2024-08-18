import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class GetAllMatch implements UseCase<List<MatchEntity>, NoParams> {
  final MatchRepository repository;
  
  GetAllMatch(this.repository);

  @override
  Future<Result<List<MatchEntity>>> call(NoParams params) async {
    return await repository.getAllMatches();
  }
}