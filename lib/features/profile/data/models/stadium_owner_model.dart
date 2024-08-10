import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/models/stadium_model.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/user/data/models/user_model.dart';

class StadiumOwnerModel extends UserModel {
  StadiumOwnerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatar,
    required super.role,
    required super.gender,
    required super.dob,
    required super.phone,
    required super.city,
    required super.district,
    required super.address,
  });

  // REMOTE DATA SOURCE
  StadiumRemoteDataSource stadiumRemoteDataSource = GetIt.instance<StadiumRemoteDataSource>();

  // DATA CONVERSION
  @override
  factory StadiumOwnerModel.fromFirestore(DocumentSnapshot userDoc) {
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

    return StadiumOwnerModel(
      id: userDoc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatar: data['avatarImage'] ?? '',
      role: data['role'] ?? '',
      dob: data['dob'] ?? '',
      gender:  data['gender'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      address: data['address'] ?? '',
    );
  }
  
  @override
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'avatarImage': avatar,
      'role': role,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'city': city,
      'district': district,
      'address': address,
    };
  }

  @override
  Future<StadiumOwner> toEntity() async {
    List<StadiumModel> stadiumModels = await stadiumRemoteDataSource.getStadiumsByOwner(id);
    List<Stadium> stadiumsEntity = await Future.wait(stadiumModels.map((e) => e.toEntity()).toList());

    return StadiumOwner(
      id: id,
      email: email,
      name: name,
      avatar: File(avatar),
      role: role,
      dob: dob,
      gender: gender,
      phone: phone,
      location: Location(city: city, district: district, address: address),
      stadiums: stadiumsEntity,
    );
  }

  @override
  factory StadiumOwnerModel.fromEntity(StadiumOwner entity) {
    return StadiumOwnerModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar.path,
      role: entity.role,
      dob: entity.dob,
      gender: entity.gender,
      phone: entity.phone,
      city: entity.location.city,
      district: entity.location.district,
      address: entity.location.address,
    );
  }
}