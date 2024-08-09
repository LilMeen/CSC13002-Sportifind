import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetNearbyStadium implements NonFutureUseCase<List<Stadium>, GetNearbyStadiumParams> {
  final StadiumRepository repository;

  GetNearbyStadium(this.repository);

  @override
  Result<List<Stadium>> call(GetNearbyStadiumParams params) {
    return repository.sortNearbyStadiums(params.stadiums, params.markedLocation);
  }
}

class GetNearbyStadiumParams {
  final List<Stadium> stadiums;
  final Location markedLocation;

  GetNearbyStadiumParams(
    this.stadiums,
    this.markedLocation
  );
}