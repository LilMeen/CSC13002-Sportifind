import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class GetNearbyStadium implements UseCase<List<Stadium>, GetNearbyStadiumParams> {
  final StadiumRepository repository;
  GetNearbyStadium(this.repository);

  @override
  Future<Result<List<Stadium>>> call(GetNearbyStadiumParams params) async {
    return repository.sortNearbyStadiums(
      stadiums: params.stadiums,
      markedLocation: params.markedLocation,
    );
  }
}

class GetNearbyStadiumParams {
  final List<Stadium> stadiums;
  final Location markedLocation;

  GetNearbyStadiumParams({
    required this.stadiums,
    required this.markedLocation,
  });
}