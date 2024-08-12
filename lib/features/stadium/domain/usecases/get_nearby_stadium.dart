import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetNearbyStadium implements NonFutureUseCase<List<StadiumEntity>, GetNearbyStadiumParams> {
  final StadiumRepository repository;

  GetNearbyStadium(this.repository);

  @override
  Result<List<StadiumEntity>> call(GetNearbyStadiumParams params) {
    return repository.sortNearbyStadiums(params.stadiums, params.markedLocation);
  }
}

class GetNearbyStadiumParams {
  final List<StadiumEntity> stadiums;
  final Location markedLocation;

  GetNearbyStadiumParams(
    this.stadiums,
    this.markedLocation
  );
}