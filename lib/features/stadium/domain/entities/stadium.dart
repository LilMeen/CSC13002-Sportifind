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


