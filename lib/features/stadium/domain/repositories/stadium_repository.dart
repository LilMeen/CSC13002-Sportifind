import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';

abstract interface class StadiumRepository {

  Future<Result<void>> createStadium(Stadium stadium); 
  Future<Result<Stadium>> getStadium(String id);
  Future<Result<List<Stadium>>> getAllStadiums();
  Future<Result<List<Stadium>>> getStadiumsByOwner(String ownerId);
  Future<Result<void>> updateStadium(Stadium stadium);
  Future<Result<void>> deleteStadium(String id);

  Result<List<Stadium>> sortNearbyStadiums(List<Stadium> stadiums, Location markedLocation);
  Result<List<Stadium>> performStadiumSearch(List<Stadium> stadiums, String searchText, String selectedCity, String selectedDistrict);
}
