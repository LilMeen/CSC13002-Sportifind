import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/user/domain/entities/user.dart';

class StadiumOwner extends UserEntity {
  List<Stadium> stadiums;

  StadiumOwner({
    required super.id,
    required super.name,
    required super.email,
    required super.avatar,
    required super.role,
    required super.gender,
    required super.dob,
    required super.location,
    required super.phone,
    
    required this.stadiums,
  });
}