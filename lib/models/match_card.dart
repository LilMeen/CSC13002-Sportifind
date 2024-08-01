import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
final formattedTime = DateFormat.Hm();

const uuid = Uuid();

class MatchCard {
  MatchCard(
      {required this.stadium,
      required this.start,
      required this.end,
      required this.date,
      required this.playTime,
      required this.avatarTeam1,
      required this.avatarTeam2,
      required this.team1,
      required this.team2,
      required this.userId,
      required this.field,})
      : id = uuid.v4();

  MatchCard.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        stadium = snapshot['stadium'],
        start = snapshot['start'],
        end = snapshot['end'],
        date =snapshot['date'],
        playTime = snapshot['playTime'],
        avatarTeam1 = snapshot['team1_avatar'],
        team1 = snapshot['team1'],
        avatarTeam2 = snapshot['team2_avatar'],
        team2 = snapshot['team2'],
        userId = snapshot['userId'],
        field = snapshot['field'];

  final String userId;
  final String id;
  String stadium;
  final String start;
  final String end;
  final String date;
  final String playTime;
  final String avatarTeam1;
  final String team1;
  final String avatarTeam2;
  final String team2;
  final String field;
}
