import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/util/search_util.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class StadiumRepositoryImpl implements StadiumRepository {
  final StadiumRemoteDataSource stadiumRemoteDataSource;

  final MatchRemoteDataSource matchRemoteDataSource;

  StadiumRepositoryImpl({
    required this.stadiumRemoteDataSource,
    required this.matchRemoteDataSource,
  });

  // CREATE STADIUM
  // Create a new stadium
  @override
  Future<Result<void>> createStadium(StadiumEntity stadium) async { 
    await stadiumRemoteDataSource.createStadium(StadiumModel.fromEntity(stadium));
    return Result.success(null);
  }


  // GET STADIUM
  // Get a stadium by its id
  @override
  Future<Result<StadiumEntity>> getStadium(String id) async {
    final stadium = await stadiumRemoteDataSource.getStadium(id);
    return Result.success(await stadium.toEntity());
  }


  // GET ALL STADIUMS
  // Get all stadiums
  @override
  Future<Result<List<StadiumEntity>>> getAllStadiums() async {
    final stadiums = await stadiumRemoteDataSource.getAllStadiums();
    List<StadiumEntity> stadiumEntities = [];
    for (StadiumModel stadium in stadiums) {
      stadiumEntities.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntities);
  }


  // GET STADIUMS BY OWNER
  // Get all stadiums by owner
  @override
  Future<Result<List<StadiumEntity>>> getStadiumsByOwner(String ownerId) async {
    final stadiums = await stadiumRemoteDataSource.getStadiumsByOwner(ownerId);
    List<StadiumEntity> stadiumEntities = [];
    for (StadiumModel stadium in stadiums) {
      stadiumEntities.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntities);
  }


  // GET FIELD BY NUMBER ID
  // Get a field by its number id
  @override
  Future<Result<FieldEntity>> getFieldByNumberId(StadiumEntity stadium, int numberId) async {
    final field = await stadiumRemoteDataSource.getFieldByNumberId(stadium.id, numberId);
    return Result.success(field.toEntity());
  }


  // GET SCHEDULE
  // Get a field's schedule of the stadium
  @override
  Future<Result<List<MatchEntity>>> getFieldScedule(FieldEntity field, String date) async {
    final matches = await stadiumRemoteDataSource.getFieldScedule(field.id, date);
    List<MatchEntity> matchEntities = [];
    for (MatchModel match in matches) {
      matchEntities.add(await match.toEntity());
    }
    return Result.success(matchEntities);
  }
  

  // UPDATE STADIUM
  // Update a stadium
  @override
  Future<Result<void>> updateStadium(StadiumEntity oldStadium, StadiumEntity newStadium) async {
    await stadiumRemoteDataSource.updateStadium(StadiumModel.fromEntity(oldStadium), StadiumModel.fromEntity(newStadium));
    return Result.success(null);
  }


  // UPDATE FIELD 
  // Update a field
  @override
  Future<Result<void>> updateField(StadiumEntity stadium) async {
    await stadiumRemoteDataSource.updateFields(StadiumModel.fromEntity(stadium));
    return Result.success(null);
  }

  // DELETE STADIUM
  // Delete a stadium by its id
  @override
  Future<Result<void>> deleteStadium(String id) async {
    List<MatchModel> relatedMatches = await matchRemoteDataSource.getMatchesByStadium(id);
    for (var match in relatedMatches) {
      await matchRemoteDataSource.deleteMatch(match.id);
    }
    await stadiumRemoteDataSource.deleteStadium(id);
    return Result.success(null);
  }


  ////////////////////////
  // NON FUTURE METHODS //
  ////////////////////////

  // SORT NEARBY STADIUMS
  // Sort stadiums by distance to a location
  @override
  Result<List<StadiumEntity>> sortNearbyStadiums(List<StadiumEntity> stadiums, Location markedLocation) {
    sortByDistance<StadiumEntity>(
      stadiums,
      markedLocation,
      (stadium) => stadium.location,
    );
    return Result.success(stadiums);
}


  // PERFORM STADIUM SEARCH
  // Search stadiums by name and location
  @override
  Result<List<StadiumEntity>> performStadiumSearch(List<StadiumEntity> stadiums,
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