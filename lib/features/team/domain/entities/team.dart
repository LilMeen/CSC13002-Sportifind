import 'dart:io';

import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/match/domain/entities/match.dart';

class Team {
  final String id;
  final String name;
  final File avatar;
  final List<Player> players;
  final Player captain;
  final String city;
  final String district;
  final List<Match> incomingMatch;

  Team ({
    required this.id,
    required this.name,
    required this.avatar,
    required this.players,
    required this.captain,
    required this.city,
    required this.district,
    required this.incomingMatch,
  });
}