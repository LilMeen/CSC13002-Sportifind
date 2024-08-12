import 'dart:io';

import 'package:sportifind/core/entities/location.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final File avatar;
  final String role;
  final String gender;
  final String dob;
  final Location location;
  final String phone;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.gender,
    required this.dob,
    required this.location,
    required this.phone,
  });


}