import 'dart:io';

import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class CreateStadium implements UseCase<void, CreateStadiumParams> {
  final StadiumRepository repository;
  CreateStadium(this.repository);

  @override
  Future<Result<void>> call(CreateStadiumParams params) async {
    return await repository.createStadium(
      name: params.name,
      location: params.location,
      phoneNumber: params.phoneNumber,
      openTime: params.openTime,
      closeTime: params.closeTime,
      pricePerHour5: params.pricePerHour5,
      pricePerHour7: params.pricePerHour7,
      pricePerHour11: params.pricePerHour11,
      num5PlayerFields: params.num5PlayerFields,
      num7PlayerFields: params.num7PlayerFields,
      num11PlayerFields: params.num11PlayerFields,
      avatar: params.avatar,
      images: params.images,
    );
  }
}

class CreateStadiumParams {
  final String name;
  final Location location;
  final String phoneNumber; 
  final String openTime;
  final String closeTime;
  final double pricePerHour5;
  final double pricePerHour7;
  final double pricePerHour11;
  final int num5PlayerFields;
  final int num7PlayerFields;
  final int num11PlayerFields;
  final File avatar;
  final List<File> images;

  CreateStadiumParams({
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.openTime,
    required this.closeTime,
    required this.pricePerHour5,
    required this.pricePerHour7,
    required this.pricePerHour11,
    required this.num5PlayerFields,
    required this.num7PlayerFields,
    required this.num11PlayerFields,
    required this.avatar,
    required this.images,
  });
}