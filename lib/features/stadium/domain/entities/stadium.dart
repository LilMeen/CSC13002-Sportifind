import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/stadium/domain/entities/field.dart';

class Stadium {
  final String id;
  final String name;
  final String owner;
  final String avatar;
  final List<String> images;
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
}


