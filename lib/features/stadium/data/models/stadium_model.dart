import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/stadium/data/models/field_model.dart';
import 'package:sportifind/features/stadium/data/models/location_model.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';

class StadiumModel {
  final String id;
  final String name;
  final String owner;
  final String avatar;
  final List<String> images;
  final LocationModel location;
  final String openTime;
  final String closeTime;
  final String phone;
  final List<FieldModel> fields;

  StadiumModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.avatar,
    required this.images,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.phone,
    required this.fields,
  });

  factory StadiumModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StadiumModel(
      id: doc.id,
      name: data['name'] ?? '',
      owner: data['owner'] ?? '',
      avatar: data['avatar'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      location: LocationModel.fromMap(data['location'] ?? {}),
      openTime: data['openTime'] ?? '',
      closeTime: data['closeTime'] ?? '',
      phone: data['phone'] ?? '',
      fields: (data['fields'] as List? ?? [])
          .map((e) => FieldModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'owner': owner,
      'avatar': avatar,
      'images': images,
      'location': location.toMap(),
      'openTime': openTime,
      'closeTime': closeTime,
      'phone': phone,
      'fields': fields.map((e) => e.toMap()).toList(),
    };
  }

  Stadium toEntity() {
    return Stadium(
      id: id,
      name: name,
      owner: owner,
      avatar: avatar,
      images: images,
      location: location.toEntity(),
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
      owner: entity.owner,
      avatar: entity.avatar,
      images: entity.images,
      location: LocationModel.fromEntity(entity.location),
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      phone: entity.phone,
      fields: entity.fields.map((e) => FieldModel.fromEntity(e)).toList(),
    );
  }
}

