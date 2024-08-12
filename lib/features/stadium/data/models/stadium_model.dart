import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/core/entities/location.dart';

class StadiumModel {
  final String id;
  final String name;
  final String phone;
  final String owner;
  final String avatar;
  final List<String> images;
  final String openTime;
  final String closeTime;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final List<FieldModel> fields;


  StadiumModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.owner,
    required this.avatar,
    required this.images,
    required this.openTime,
    required this.closeTime,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.fields,
  });

  factory StadiumModel.fromFirestore(DocumentSnapshot stadiumDoc, List<DocumentSnapshot> fieldDocs) {
    Map<String, dynamic> data = stadiumDoc.data() as Map<String, dynamic>;
    List<FieldModel> fields = fieldDocs.map((e) => FieldModel.fromFirestore(e)).toList();
    
    return StadiumModel(
      id: stadiumDoc.id,
      name: data['name'] ?? '',
      phone: data['phone_number'] ?? '',
      owner: data['owner'] ?? '',
      avatar: data['avatar'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      openTime: data['open_time'] ?? '',
      closeTime: data['close_time'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      address: data['address'] ?? '',
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      fields: fields,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone_number': phone,
      'owner': owner,
      'avatar': avatar,
      'images': images,
      'open_time': openTime,
      'close_time': closeTime,
      'city': city,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Future <Stadium> toEntity() async {
    Location googleLocation = await getLocation('$latitude, $longitude');
    Location location = googleLocation.copyWith(
      name: googleLocation.name,
      fullAddress: googleLocation.fullAddress,
      address: address,
      district: district,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
    return Stadium(
      id: id,
      name: name,
      ownerId: owner,
      avatar: File(avatar),
      images: List<File>.from(images.map((e) => File(e))),
      location: location,
      openTime: openTime,
      closeTime: closeTime,
      phone: phone,
      fields: fields.map((e) => e.toEntity()).toList(),
    );
  }

  factory StadiumModel.fromEntity(Stadium entity) {
    return StadiumModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      owner: entity.ownerId,
      avatar: entity.avatar.path,
      images: entity.images.map((e) => e.path).toList(),
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      city: entity.location.city,
      district: entity.location.district,
      address: entity.location.address,
      latitude: entity.location.latitude,
      longitude: entity.location.longitude,
      fields: entity.fields.map((e) => FieldModel.fromEntity(e)).toList(),
    );
  }
}

