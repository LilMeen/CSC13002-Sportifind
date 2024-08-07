
import 'dart:io';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';
import 'package:sportifind/services/location_service.dart';
import 'package:sportifind/services/search_service.dart';

class StadiumRepositoryImpl implements StadiumRepository {
  final StadiumRemoteDataSource stadiumRemoteDataSource;

  StadiumRepositoryImpl({
    required this.stadiumRemoteDataSource,
  });

  @override
  Future<Result<void>> createStadium({
    required String name,
    required Location location,
    required String phoneNumber,
    required String openTime,
    required String closeTime,
    required double pricePerHour5,
    required double pricePerHour7,
    required double pricePerHour11,
    required int num5PlayerFields,
    required int num7PlayerFields,
    required int num11PlayerFields,
    required File avatar,
    required List<File> images,
  }) async { 
    await stadiumRemoteDataSource.createStadium(
      name: name,
      location: location,
      phoneNumber: phoneNumber,
      openTime: openTime,
      closeTime: closeTime,
      pricePerHour5: pricePerHour5,
      pricePerHour7: pricePerHour7,
      pricePerHour11: pricePerHour11,
      num5PlayerFields: num5PlayerFields,
      num7PlayerFields: num7PlayerFields,
      num11PlayerFields: num11PlayerFields,
      avatar: avatar,
      images: images,
    );
    return Result.success(null);
  }
  
  @override
  Future<Result<void>> updateStadium({
    required String id,
    required String name,
    required Location location,
    required String phoneNumber,
    required String openTime,
    required String closeTime,
    required double pricePerHour5,
    required double pricePerHour7,
    required double pricePerHour11,
    required int num5PlayerFields,
    required int num7PlayerFields,
    required int num11PlayerFields,
    required File avatar,
    required List<File> images,
  }) async { 
    await stadiumRemoteDataSource.updateStadium(
      id: id,
      name: name,
      location: location,
      phoneNumber: phoneNumber,
      openTime: openTime,
      closeTime: closeTime,
      pricePerHour5: pricePerHour5,
      pricePerHour7: pricePerHour7,
      pricePerHour11: pricePerHour11,
      num5PlayerFields: num5PlayerFields,
      num7PlayerFields: num7PlayerFields,
      num11PlayerFields: num11PlayerFields,
      avatar: avatar,
      images: images,
    );
    return Result.success(null);
  }


  @override
  Future<Result<void>> updateFieldStatus({
    required String stadiumId,
    required String fieldId,
    required bool status,
  }) async { 
    await stadiumRemoteDataSource.updateFieldStatus(
      stadiumId: stadiumId,
      fieldId: fieldId,
      status: status,
    );
    return Result.success(null);
  }


  @override
  Future<Result<List<Stadium>>> getStadiumList() async { 
    final stadiumList = await stadiumRemoteDataSource.getStadiumList();
    var stadiumEntityList = <Stadium>[];
    for (var stadium in stadiumList){
      stadiumEntityList.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntityList);
  }


  @override
  Future<Result<Stadium>> getStadiumById({required String id}) async { 
    final stadium = await stadiumRemoteDataSource.getStadiumById(id: id);
    return Result.success(await stadium.toEntity());
  }


  @override
  Future<Result<List<Stadium>>> getStadiumsByOwner({required String owner}) async { 
    final stadiums = await stadiumRemoteDataSource.getStadiumsByOwner(owner: owner);
    final stadiumEntityList = <Stadium>[];
    for (var stadium in stadiums){
      stadiumEntityList.add(await stadium.toEntity());
    }
    return Result.success(stadiumEntityList );
  }


  @override
  Result<List<Stadium>> sortNearbyStadiums({    
    required List<Stadium> stadiums,
    required Location markedLocation,
  }) { 
    LocationService().sortByDistance<Stadium>(
      stadiums,
      markedLocation,
      (stadium) => stadium.location,
    );
    return Result.success(stadiums);
  }


  @override
  Result<List<Stadium>> performStadiumSearch({
    required List<Stadium> stadiums,
    required String searchText,
    required String selectedCity,
    required String selectedDistrict,
  }) { 
      final result = SearchService().searchingNameAndLocation(
        listItems: stadiums,
        searchText: searchText,
        selectedCity: selectedCity,
        selectedDistrict: selectedDistrict,
        getNameOfItem: (stadium) => stadium.name,
        getLocationOfItem: (stadium) => stadium.location,
      );
    return Result.success(result);
  }


  @override
  Future<Result<void>> deleteStadium({required String id}) async { 
    await stadiumRemoteDataSource.deleteStadium(id: id);
    return Result.success(null);
  }
}