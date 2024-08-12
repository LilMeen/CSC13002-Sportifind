import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class StadiumOwnerEntity extends UserEntity {
  List<StadiumEntity> stadiums;

  StadiumOwnerEntity({
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