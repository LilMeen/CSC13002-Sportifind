import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';
import 'package:sportifind/features/user/data/models/user_model.dart';

class PlayerModel extends UserModel {
  final String height;
  final String weight;
  final String preferredFoot;
  final Map<String, int> stats;
  final List<String> teams;

  PlayerModel({
    required super.id,
    required super.email,
    required super.name,
    required super.avatar,
    required super.role,
    required super.dob,
    required super.gender,
    required super.phone,
    required super.city,
    required super.district,
    required super.address,

    required this.height,
    required this.weight,
    required this.preferredFoot,
    required this.stats,
    required this.teams,
  });


  // REMOTE DATA SOURCE
  TeamRemoteDataSource teamRemoteDataSource = TeamRemoteDataSourceImpl();

  // DATA CONVERSION
  @override
  factory PlayerModel.fromFirestore(DocumentSnapshot playerDoc) {
    Map<String, dynamic> data = playerDoc.data() as Map<String, dynamic>;

    return PlayerModel(
      id: playerDoc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatar: data['avatarImage'] ?? '',
      role: data['role'] ?? '',
      dob: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      district: data['district'] ?? '',
      address: data['address'] ?? '',
      height: data['height'] ?? '',
      weight: data['weight'] ?? '',
      preferredFoot: data['preferredFoot'] ?? '',
      stats: data['stats'] ?? {},
      teams: data['joinedTeams'] ?? [],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'avatarImage': avatar,
      'role': role,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'city': city,
      'district': district,
      'address': address,
      'height': height,
      'weight': weight,
      'preferredFoot': preferredFoot,
      'stats': stats,
      'joinedTeams': teams,
    };
  }

  @override
  Future<PlayerEntity> toEntity() async {
    Stats statsEntity = Stats(
      def: stats['DEF'] ?? 0,
      drive: stats['DRIVE'] ?? 0,
      pace: stats['PACE'] ?? 0,
      pass: stats['PASS'] ?? 0,
      physic: stats['PHYSIC'] ?? 0,
      shoot: stats['SHOOT'] ?? 0,
    );

    return PlayerEntity(
      id: id,
      email: email,
      name: name,
      avatar: File(avatar),
      role: role,
      dob: dob,
      gender: gender,
      phone: phone,
      location: Location(city: city, district: district, address: address),
      height: height,
      weight: weight,
      preferredFoot: preferredFoot,
      stats: statsEntity,
      teamsId: teams,
    );
  }

  @override
  factory PlayerModel.fromEntity(PlayerEntity entity) {
    return PlayerModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar.path,
      role: entity.role,
      dob: entity.dob,
      gender: entity.gender,
      phone: entity.phone,
      city: entity.location.city,
      district: entity.location.district,
      address: entity.location.address,
      height: entity.height,
      weight: entity.weight,
      preferredFoot: entity.preferredFoot,
      stats: {
        'DEF': entity.stats.def,
        'DRIVE': entity.stats.drive,
        'PACE': entity.stats.pace,
        'PASS': entity.stats.pass,
        'PHYSIC': entity.stats.physic,
        'SHOOT': entity.stats.shoot,
      },
      teams: entity.teamsId,
    );
  }
}