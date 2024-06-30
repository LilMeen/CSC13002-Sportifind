import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
final formattedTime = DateFormat.Hm();

const uuid = Uuid();

class MatchCard {
  MatchCard(
      {required this.stadium,
      required this.startHour,
      required this.endHour,
      required this.date,
      required this.playTime,
      required this.avatarTeam1,
      required this.avatarTeam2,
      required this.team1,
      required this.team2,
      required this.userId,})
      : id = uuid.v4();

  MatchCard.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        stadium = snapshot['stadium'],
        startHour = snapshot['startHour'],
        endHour = snapshot['endHour'],
        date = snapshot['date'].toDate(),
        playTime = snapshot['playTime'],
        avatarTeam1 = snapshot['leftTeamAvatar'],
        team1 = snapshot['leftTeamName'],
        avatarTeam2 = snapshot['rightTeamAvatar'],
        team2 = snapshot['rightTeamName'],
        userId = snapshot['userId'];

  final String userId;
  final String id;
  final String stadium;
  final String startHour;
  final String endHour;
  final DateTime date;
  final String playTime;
  final String avatarTeam1;
  final String team1;
  final String avatarTeam2;
  final String team2;

  String get formattedDate {
    return formatter.format(date);
  }
}
