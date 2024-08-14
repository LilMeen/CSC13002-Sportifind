import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/repositories/match_repository.dart';

class GetNearbyMatch implements NonFutureUseCase<List<MatchEntity>, GetNearbyMatchParams> {
  final MatchRepository repository;
  
  GetNearbyMatch(this.repository);

  @override
  Result<List<MatchEntity>> call(GetNearbyMatchParams params) {
    return repository.sortNearbyMatches(params.matches, params.markedLocation);
  }
}

class GetNearbyMatchParams {
  final List<MatchEntity> matches;
  final Location markedLocation;

  GetNearbyMatchParams(
    this.matches,
    this.markedLocation
  );
}