import 'dart:io';

import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';

class Team {
  final String id;
  final String name;
  final File avatar;
  final List<Player> players;
  final Player captain;
  final Location location;
  final Map<String, bool> incomingMatch;

  Team ({
    required this.id,
    required this.name,
    required this.avatar,
    required this.players,
    required this.captain,
    required this.location,
    required this.incomingMatch,
  });
}