
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/util/search_util.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class StadiumRepositoryImpl implements StadiumRepository {
  final StadiumRemoteDataSource stadiumRemoteDataSource;

  StadiumRepositoryImpl({
    required this.stadiumRemoteDataSource,
  });

  // CREATE STADIUM
  // Create a new stadium
  @override
  Future<Result<void>> createStadium(Stadium stadium) async { 
    await stadiumRemoteDataSource.createStadium(StadiumModel.fromEntity(stadium));
    return Result.success(null);
  }


  // GET STADIUM
  // Get a stadium by its id
  @override
  Future<Result<Stadium>> getStadium(String id) async {
    final stadium = await stadiumRemoteDataSource.getStadium(id);
    return Result.success(await stadium.toEntity());
  }


  // GET ALL STADIUMS
  // Get all stadiums
  @override
  Future<Result<List<Stadium>>> getAllStadiums() async {
    final stadiums = await stadiumRemoteDataSource.getAllStadiums();
    List<Stadium> stadiumEntities = [];
    for (StadiumModel stadium in stadiums) {
      stadiumEntities.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntities);
  }


  // GET STADIUMS BY OWNER
  // Get all stadiums by owner
  @override
  Future<Result<List<Stadium>>> getStadiumsByOwner(String ownerId) async {
    final stadiums = await stadiumRemoteDataSource.getStadiumsByOwner(ownerId);
    List<Stadium> stadiumEntities = [];
    for (StadiumModel stadium in stadiums) {
      stadiumEntities.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntities);
  }


  // UPDATE STADIUM
  // Update a stadium
  @override
  Future<Result<void>> updateStadium(Stadium stadium) async {
    await stadiumRemoteDataSource.updateStadium(StadiumModel.fromEntity(stadium));
    return Result.success(null);
  }


  // SORT NEARBY STADIUMS
  // Sort stadiums by distance to a location
  @override
  Result<List<Stadium>> sortNearbyStadiums(List<Stadium> stadiums, Location markedLocation) {
    sortByDistance<Stadium>(
      stadiums,
      markedLocation,
      (stadium) => stadium.location,
    );
    return Result.success(stadiums);
}


// PERFORM STADIUM SEARCH
// Search stadiums by name and location
@override
Result<List<Stadium>> performStadiumSearch(List<Stadium> stadiums,
    String searchText, String selectedCity, String selectedDistrict) {
  return Result.success(searchingNameAndLocation(
    listItems: stadiums,
    searchText: searchText,
    selectedCity: selectedCity,
    selectedDistrict: selectedDistrict,
    getNameOfItem: (stadium) => stadium.name,
    getLocationOfItem: (stadium) => stadium.location,
  ));
}
}