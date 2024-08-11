import 'dart:io';

import 'package:sportifind/features/stadium/domain/entities/field.dart';
import 'package:sportifind/core/entities/location.dart';

class Stadium {
  final String id;
  final String name;
  final String owner;
  final File avatar;
  final List<File> images;
  final Location location;
  final String openTime;
  final String closeTime;
  final String phone;
  final List<Field> fields;

  Stadium({
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

  Stadium copyWith ({
    String? id,
    String? name,
    String? owner,
    File? avatar,
    List<File>? images,
    Location? location,
    String? openTime,
    String? closeTime,
    String? phone,
    List<Field>? fields,
  }) {
    return Stadium(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
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


