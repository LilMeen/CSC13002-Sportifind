import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/match/data/datasources/match_remote_data_source.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class TeamModel {
  final String id;
  final String avatarImage;
  final List<String> images;
  final String captain;
  final String city;
  final String district;
  final Timestamp foundedDate;
  final String name;
  final List<String> players;
  final Map<String, bool> incomingMatch;
  final List<String> matchSendRequest;
  final List<String> matchInviteRequest;
  final List<String> invitedPlayers;
  final List<String> joinRequestsFromPlayers;

  TeamModel({
    required this.id,
    required this.avatarImage,
    required this.images,
    required this.captain,
    required this.city,
    required this.district,
    required this.foundedDate,
    required this.name,
    required this.players,
    required this.incomingMatch,
    required this.matchSendRequest,
    required this.matchInviteRequest,
    required this.invitedPlayers,
    required this.joinRequestsFromPlayers,
  });

  // REMOTE DATA SOURCE
  ProfileRemoteDataSource profileRemoteDataSource =
      GetIt.instance<ProfileRemoteDataSource>();
  MatchRemoteDataSource matchRemoteDataSource =
      GetIt.instance<MatchRemoteDataSource>();

  // DATA CONVERSION
  factory TeamModel.fromFirestore(DocumentSnapshot teamDoc) {
    Map<String, dynamic> data = teamDoc.data() as Map<String, dynamic>;

    return TeamModel(
      id: teamDoc.id,
      avatarImage: data['avatarImage'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      captain: data['captain'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      foundedDate: data['foundedDate'] ?? '',
      name: data['name'] ?? '',
      players: List<String>.from(data['members'] ?? []),
      incomingMatch: Map<String, bool>.from(data['incomingMatch'] ?? {}),
      matchSendRequest: List<String>.from(data['matchSendRequest'] ?? []),
      matchInviteRequest: List<String>.from(data['matchInviteRequest'] ?? []),
      invitedPlayers: List<String>.from(data['invitedPlayers'] ?? []),
      joinRequestsFromPlayers: List<String>.from(data['joinRequestsFromPlayers'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'avatarImage': avatarImage,
      'images': images,
      'captain': captain,
      'city': city,
      'district': district,
      'foundedDate': foundedDate,
      'name': name,
      'members': players,
      'incomingMatch': incomingMatch,
      'matchSendRequest': matchSendRequest,
      'matchInviteRequest': matchInviteRequest,
      'invitedPlayers': invitedPlayers,
      'joinRequestsFromPlayers': joinRequestsFromPlayers,
    };
  }

  Future<TeamEntity> toEntity() async {
    PlayerEntity captainEntity = await profileRemoteDataSource
        .getPlayer(captain)
        .then((value) => value.toEntity());
    List<PlayerEntity> playersEntity = [];
    for (var playerId in players) {
      final player = await profileRemoteDataSource.getPlayer(playerId);
      playersEntity.add(await player.toEntity());
    }
    Location teamLocation = Location(city: city, district: district);

    List<PlayerEntity> invitedPlayersEntity = [];
    for (var playerId in invitedPlayers) {
      final player = await profileRemoteDataSource.getPlayer(playerId);
      invitedPlayersEntity.add(await player.toEntity());
    }

    List<PlayerEntity> joinRequestsFromPlayersEntity = [];
    for (var playerId in joinRequestsFromPlayers) {
      final player = await profileRemoteDataSource.getPlayer(playerId);
      joinRequestsFromPlayersEntity.add(await player.toEntity());
    }

    return TeamEntity(
      id: id,
      avatar: File(avatarImage),
      images: images.map((e) => File(e)).toList(),
      foundedDate: foundedDate.toDate(),
      captain: captainEntity,
      location: teamLocation,
      name: name,
      players: playersEntity,
      incomingMatch: incomingMatch,
      invitedPlayers: invitedPlayersEntity,
      joinRequestsFromPlayers: joinRequestsFromPlayersEntity,
    );
  }

  factory TeamModel.fromEntity(TeamEntity team) {
    return TeamModel(
      id: team.id,
      avatarImage: team.avatar.path,
      images: team.images?.map((e) => e.path).toList() ?? [],
      captain: team.captain.id,
      city: team.location.city,
      district: team.location.district,
      foundedDate: Timestamp.fromDate(team.foundedDate),
      name: team.name,
      players: team.players.map((e) => e.id).toList(),
      incomingMatch: team.incomingMatch,
      matchSendRequest:
          team.matchSendRequest?.map((e) => e.matchId).toList() ?? [],
      matchInviteRequest:
          team.matchInviteRequest?.map((e) => e.matchId).toList() ?? [],
      invitedPlayers: 
          team.invitedPlayers?.map((e) => e.id).toList() ?? [],
      joinRequestsFromPlayers:
          team.joinRequestsFromPlayers?.map((e) => e.id).toList() ?? [],
    );
  }
}
