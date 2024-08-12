import 'package:sportifind/features/user/domain/entities/user.dart';

class Player extends UserEntity {
  final String height;
  final String weight;
  final String preferredFoot;
  final Stats stats;
  final List<String> teamsId;

  Player({
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
  final int def;
  final int drive;
  final int pace;
  final int pass;
  final int physic;
  final int shoot;

  Stats({
    required this.def,
    required this.drive,
    required this.pace,
    required this.pass,
    required this.physic,
    required this.shoot,
  });
}