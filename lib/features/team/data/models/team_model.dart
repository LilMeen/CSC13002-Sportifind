import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/profile/domain/entities/player.dart';
import 'package:sportifind/features/team/domain/entities/team.dart';

class TeamModel {
  final String id;
  final String avatarImage;
  final String captain;
  final String city;
  final String district;
  final Timestamp foundedDate;
  final String name;
  final List<String> players;
  final Map<String, bool> incomingMatch;

  TeamModel({
    required this.id,
    required this.avatarImage,
    required this.captain,
    required this.city,
    required this.district,
    required this.foundedDate,
    required this.name,
    required this.players,
    required this.incomingMatch,
  });

  // REMOTE DATA SOURCE
  ProfileRemoteDataSource profileRemoteDataSource = GetIt.instance<ProfileRemoteDataSource>();


  // DATA CONVERSION
  factory TeamModel.fromFirestore(DocumentSnapshot teamDoc) {
    Map<String, dynamic> data = teamDoc.data() as Map<String, dynamic>;

    return TeamModel(
      id: teamDoc.id,
      avatarImage: data['avatarImage'] ?? '',
      captain: data['captain'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      foundedDate: data['foundedDate'] ?? '',
      name: data['name'] ?? '',
      players: List<String>.from(data['members'] ?? []),
      incomingMatch: Map<String, bool>.from(data['incomingMatch'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatarImage': avatarImage,
      'captain': captain,
      'city': city,
      'district': district,
      'foundedDate': foundedDate,
      'name': name,
      'members': players,
      'incomingMatch': incomingMatch,
    };
  }

  Future<Team> toEntity() async{
    Player captainEntity = await profileRemoteDataSource.getPlayer(captain).then((value) => value.toEntity());
    List<Player> playersEntity = await Future.wait(
      players.map(
        (e) => profileRemoteDataSource.getPlayer(e).then((value) => value.toEntity())
      )
    );
    Location googleLocation = await findLatAndLngFull('', district, city) ;

    return Team(
      id: id,
      avatar: File(avatarImage),
      captain: captainEntity,
      location: googleLocation,
      name: name,
      players: playersEntity,
      incomingMatch: incomingMatch,
    );
  }

  factory TeamModel.fromEntity(Team team) {

    return TeamModel(
      id: team.id,
      avatarImage: team.avatar.path,
      captain: team.captain.id,
      city: team.location.city,
      district: team.location.district,
      foundedDate: Timestamp.now(),
      name: team.name,
      players: team.players.map((e) => e.id).toList(),
      incomingMatch: team.incomingMatch,
    );
  }
}