import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class MatchEntity {
  final String id;
  final StadiumEntity stadium;
  final FieldEntity field;
  final String date;
  final String start;
  final String end;
  final String playTime;
  final TeamEntity team1;
  final TeamEntity? team2;

  MatchEntity({
    required this.id,
    required this.stadium,
    required this.field,
    required this.date,
    required this.start,
    required this.end,
    required this.playTime,
    required this.team1,
    required this.team2,
  });
}