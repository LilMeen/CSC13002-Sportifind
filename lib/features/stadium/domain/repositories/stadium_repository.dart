import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';

abstract interface class StadiumRepository {

  Future<Result<void>> createStadium(StadiumEntity stadium); 
  Future<Result<StadiumEntity>> getStadium(String id);
  Future<Result<List<StadiumEntity>>> getAllStadiums();
  Future<Result<List<StadiumEntity>>> getStadiumsByOwner(String ownerId);
  Future<Result<void>> updateStadium(StadiumEntity stadium);
  Future<Result<void>> deleteStadium(String id);

  Result<List<StadiumEntity>> sortNearbyStadiums(List<StadiumEntity> stadiums, Location markedLocation);
  Result<List<StadiumEntity>> performStadiumSearch(List<StadiumEntity> stadiums, String searchText, String selectedCity, String selectedDistrict);
}
