import 'package:sportifind/core/entities/location.dart';

class StadiumOwner {
  final String id;
  final String name;
  final String email;
  final String role;
  final String gender;
  final String dob;
  final Location location;
  final String phone;

  StadiumOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.dob,
    required this.location,
    required this.phone,
  });
}