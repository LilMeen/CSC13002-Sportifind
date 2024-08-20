import 'package:sportifind/features/user/domain/entities/user_entity.dart';

class PlayerEntity extends UserEntity {
  String height;
  String weight;
  String preferredFoot;
  Stats stats;
  List<String> teamsId;

  PlayerEntity({
    required super.id,
    required super.name,
    required super.email,
    required super.avatar,
    required super.role,
    required super.gender,
    required super.dob,
    required super.location,
    required super.phone,

    required this.height,
    required this.weight,
    required this.preferredFoot,
    required this.stats,
    required this.teamsId,
  });
}


class Stats {
  int def;
  int drive;
  int pace;
  int pass;
  int physic;
  int shoot;

  Stats({
    required this.def,
    required this.drive,
    required this.pace,
    required this.pass,
    required this.physic,
    required this.shoot,
  });
}