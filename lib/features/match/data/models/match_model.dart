import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sportifind/features/match/domain/entities/match.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';

class MatchModel {
  final String id;
  final String stadium;
  final String field;
  final String stadiumOwner;
  final String date;
  final String start;
  final String end;
  final String playTime;
  final String team1;
  final String team1Avatar;
  final String team2;
  final String team2Avatar;

  MatchModel({
    required this.id,
    required this.stadium,
    required this.field,
    required this.stadiumOwner,
    required this.date,
    required this.start,
    required this.end,
    required this.playTime,
    required this.team1,
    required this.team1Avatar,
    required this.team2,
    required this.team2Avatar,
  });


  // REMOTE DATA SOURCE
  final stadiumRemoteDataSource = GetIt.instance<StadiumRemoteDataSource>();
  final teamRemoteDataSource = GetIt.instance<TeamRemoteDataSource>();
  final profileRemoteDataSource = GetIt.instance<ProfileRemoteDataSource>();

  // DATA CONVERSION
  factory MatchModel.fromFirestore(DocumentSnapshot matchDoc) {
    Map<String, dynamic> data = matchDoc.data() as Map<String, dynamic>;

    return MatchModel(
      id: matchDoc.id,
      stadium: data['stadium'] ?? '',
      field: data['field'] ?? '',
      stadiumOwner: data['stadium_owner'] ?? '',
      date: data['date'] ?? '',
      start: data['start'] ?? '',
      end: data['end'] ?? '',
      playTime: data['playTime'] ?? '',
      team1: data['team1'] ?? '',
      team1Avatar: data['team1_avatar'] ?? '',
      team2: data['team2'] ?? '',
      team2Avatar: data['team2_avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stadium': stadium,
      'field': field,
      'stadium_owner': stadiumOwner,
      'date': date,
      'start': start,
      'end': end,
      'playTime': playTime,
      'team1': team1,
      'team1_avatar': team1Avatar,
      'team2': team2,
      'team2_avatar': team2Avatar,
    };
  }

  Future<Match> toEntity() async{
    final stadiumEndity = await stadiumRemoteDataSource.getStadium(stadium).then((value) => value.toEntity());
    final fieldEntity = stadiumEndity.fields.firstWhere((element) => element.id == field);
    final team1Entity = await teamRemoteDataSource.getTeam(team1).then((value) => value.toEntity());
    final team2Entity = await teamRemoteDataSource.getTeam(team2).then((value) => value.toEntity());

    return Match(
      id: id,
      stadium: stadiumEndity,
      field: fieldEntity,
      date: date,
      start: start,
      end: end,
      playTime: playTime,
      team1: team1Entity,
      team2: team2Entity,
    );
  }

  MatchModel fromEntity(Match match) {
    return MatchModel(
      id: match.id,
      stadium: match.stadium.id,
      field: match.field.id,
      stadiumOwner: match.stadium.ownerId,
      date: match.date,
      start: match.start,
      end: match.end,
      playTime: match.playTime,
      team1: match.team1.id,
      team1Avatar: match.team1.avatar.path,
      team2: match.team2.id,
      team2Avatar: match.team2.avatar.path,
    );
  }
}