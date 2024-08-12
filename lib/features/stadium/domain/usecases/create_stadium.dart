import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class CreateStadium implements UseCase<void, CreateStadiumParams> {
  final StadiumRepository repository;
  CreateStadium(this.repository);

  @override
  Future<Result<void>> call(CreateStadiumParams params) async {
    List<FieldEntity> fields = [];
    int numberId = 1;
    void addFields(int numFields, double price, String type) {
      for (int i = 0; i < numFields; i++) {
        fields.add(FieldEntity(
          id: '',
          numberId: numberId++,
          type: type,
          price: price,
          status: true,
        ));
      }
    }
    addFields(params.num5PlayerFields, params.pricePerHour5, '5-player');
    addFields(params.num7PlayerFields, params.pricePerHour7, '7-player');
    addFields(params.num11PlayerFields, params.pricePerHour11, '11-player');

    StadiumEntity stadium = StadiumEntity(
      id: '',
      name: params.name,
      ownerId: FirebaseAuth.instance.currentUser!.uid,
      avatar: params.avatar,
      images: params.images,
      location: params.location,
      openTime: params.openTime,
      closeTime: params.closeTime,
      phone: params.phoneNumber,
      fields: fields,
    );
    return await repository.createStadium(stadium);
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