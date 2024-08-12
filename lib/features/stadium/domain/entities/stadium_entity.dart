import 'dart:io';

import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/core/entities/location.dart';

class StadiumEntity {
  final String id;
  final String name;
  final String ownerId;
  final File avatar;
  final List<File> images;
  final Location location;
  final String openTime;
  final String closeTime;
  final String phone;
  final List<FieldEntity> fields;

  StadiumEntity({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.avatar,
    required this.images,
    required this.location,
    required this.openTime,
    required this.closeTime,
    required this.phone,
    required this.fields,
  });

  StadiumEntity copyWith ({
    String? id,
    String? name,
    String? ownerId,
    File? avatar,
    List<File>? images,
    Location? location,
    String? openTime,
    String? closeTime,
    String? phone,
    List<FieldEntity>? fields,
  }) {
    return StadiumEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      avatar: avatar ?? this.avatar,
      images: images ?? this.images,
      location: location ?? this.location,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      phone: phone ?? this.phone,
      fields: fields ?? this.fields,
    );
  }

  int getNumberOfTypeField(String type) {
    return fields.where((field) => field.type == type).length;
  }

  double getPriceOfTypeField(String type) {
    for (var field in fields) {
      if (field.type == type) {
        return field.price;
      }
    }
    return 0;
  }
}


