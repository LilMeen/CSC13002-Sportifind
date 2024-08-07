import 'dart:io';

import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';

abstract interface class StadiumRepository {

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
  }); 

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
  });
  Future<Result<void>> updateFieldStatus({
    required String stadiumId,
    required String fieldId,
    required bool status,
  });


  Future<Result<List<Stadium>>> getStadiumList();
  Future<Result<Stadium>> getStadiumById({required String id});
  Future<Result<List<Stadium>>> getStadiumsByOwner({required String owner});


  Result<List<Stadium>> sortNearbyStadiums({    
    required List<Stadium> stadiums,
    required Location markedLocation,
  });
  Result<List<Stadium>> performStadiumSearch({
    required List<Stadium> stadiums,
    required String searchText,
    required String selectedCity,
    required String selectedDistrict,
  });


  Future<Result<void>> deleteStadium({required String id});
}

