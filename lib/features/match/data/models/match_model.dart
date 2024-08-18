import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sportifind/features/stadium/data/datasources/stadium_remote_data_source.dart';
import 'package:sportifind/features/team/data/datasources/team_remote_data_source.dart';

class MatchModel {
  final String id;
  final String stadiumId;
  final String fieldId;
  final String stadiumOwnerId;
  final String date;
  final String start;
  final String end;
  final String playTime;
  final String team1Id;
  final String team2Id;

  MatchModel({
    required this.id,
    required this.stadiumId,
    required this.fieldId,
    required this.stadiumOwnerId,
    required this.date,
    required this.start,
    required this.end,
    required this.playTime,
    required this.team1Id,
    required this.team2Id,
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
      stadiumId: data['stadium'] ?? '',
      fieldId: data['field'] ?? '',
      stadiumOwnerId: data['stadiumOwner'] ?? '',
      date: data['date'] ?? '',
      start: data['start'] ?? '',
      end: data['end'] ?? '',
      playTime: data['playTime'] ?? '',
      team1Id: data['team1'] ?? '',
      team2Id: data['team2'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'stadium': stadiumId,
      'field': fieldId,
      'stadiumOwner': stadiumOwnerId,
      'date': date,
      'start': start,
      'end': end,
      'playTime': playTime,
      'team1': team1Id,
      'team2': team2Id,
    };
  }

  Future<MatchEntity> toEntity() async{
    final stadiumEndity = await stadiumRemoteDataSource.getStadium(stadiumId).then((value) => value.toEntity());
    final fieldEntity = stadiumEndity.fields.firstWhere((element) => element.id == fieldId);
  
    final team1 = await teamRemoteDataSource.getTeam(team1Id).then((value) => value.toEntity());
    final team2 = team2Id != '' ? await teamRemoteDataSource.getTeam(team2Id).then((value) => value.toEntity()) : null;
    return MatchEntity(
      id: id,
      stadium: stadiumEndity,
      field: fieldEntity,
      date: date,
      start: start,
      end: end,
      playTime: playTime,
      team1: team1,
      team2: team2,
    );
  }

  factory MatchModel.fromEntity(MatchEntity match) {
    return MatchModel(
      id: match.id,
      stadiumId: match.stadium.id,
      fieldId: match.field.id,
      stadiumOwnerId: match.stadium.ownerId,
      date: match.date,
      start: match.start,
      end: match.end,
      playTime: match.playTime,
      team1Id: match.team1.id,
      team2Id: match.team2 != null ?  match.team2!.id : '',
    );
  }
}