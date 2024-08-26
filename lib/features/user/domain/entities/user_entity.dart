import 'dart:io';
import 'package:sportifind/core/entities/location.dart';

class UserEntity {
  String id;
  String name;
  String email;
  File avatar;
  String role;
  String gender;
  String dob;
  Location location;
  String phone;

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