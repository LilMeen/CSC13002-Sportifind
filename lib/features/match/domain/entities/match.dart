import 'package:sportifind/features/stadium/domain/entities/field.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/team/domain/entities/team.dart';

class Match {
  final String id;
  final Stadium stadium;
  final Field field;
  final String date;
  final String start;
  final String end;
  final String playTime;
  final Team team1;
  final Team team2;

  Match({
    required this.id,
    required this.stadium,
    required this.field,
    required this.date,
    required this.start,
    required this.end,
    required this.playTime,
    required this.team1,
    required this.team2
  });
}