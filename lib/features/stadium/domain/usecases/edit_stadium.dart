import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/models/result.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/features/stadium/domain/entities/field.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/repositories/stadium_repository.dart';

class EditStadium implements UseCase<void, EditStadiumParams> {
  final StadiumRepository repository;
  EditStadium(this.repository);

  @override
  Future<Result<void>> call(EditStadiumParams params) async {
    List<Field> fields = [];
    int numberId = 1;
    void addFields(int numFields, double price, String type) {
      for (int i = 0; i < numFields; i++) {
        fields.add(Field(
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

    Stadium stadium = Stadium(
      id: params.id,
      name: params.name,
      owner: FirebaseAuth.instance.currentUser!.uid,
      avatar: params.avatar,
      images: params.images,
      location: params.location,
      openTime: params.openTime,
      closeTime: params.closeTime,
      phone: params.phoneNumber,
      fields: fields,
    );
    return await repository.updateStadium(stadium);
  }
}

class EditStadiumParams {
  final String id;
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



  EditStadiumParams({
    required this.id,
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