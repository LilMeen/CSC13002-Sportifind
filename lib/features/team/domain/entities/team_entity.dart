import 'dart:io';

import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';

class TeamEntity {
  String id;
  String name;
  File avatar;
  DateTime foundedDate;
  List<PlayerEntity> players;
  PlayerEntity captain;
  Location location;
  Map<String, bool> incomingMatch;
  List<File>? images;
  List<MatchRequest>? matchSendRequest;
  List<MatchRequest>? matchInviteRequest;

  TeamEntity ({
    required this.id,
    required this.name,
    required this.avatar,
    required this.foundedDate,
    required this.players,
    required this.captain,
    required this.location,
    required this.incomingMatch,
    this.images,
    this.matchSendRequest,
    this.matchInviteRequest,
  });
}

class MatchRequest{
  String matchId;
  String receiverId;
  String senderId;

  MatchRequest({
    required this.matchId,
    required this.receiverId,
    required this.senderId,
  });
}