import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/models/match_card.dart';

class TeamInformation {
  TeamInformation({
    required this.teamId,
    required this.name,
    required this.address,
    required this.district,
    required this.city,
    required this.avatarImageUrl,
    required this.members,
    required this.incoming,
    this.matchSentRequest,
    this.matchInviteRequest,
    required this.captain,
  });

  TeamInformation.empty()
      : teamId = '',
        name = '',
        address = '',
        district = '',
        city = '',
        avatarImageUrl = '',
        incoming = {},
        matchSentRequest = [],
        matchInviteRequest = [],
        members = [],
        captain = '';

  TeamInformation.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        district = snapshot['district'],
        city = snapshot['city'],
        avatarImageUrl = snapshot['avatarImage'],
        incoming = Map<String, bool>.from(snapshot['incomingMatch']),
        members = (snapshot['members'] as List)
            .map((item) => item as String)
            .toList(),
        matchSentRequest = (snapshot.data()?['matchSentRequest'] as List?)
                ?.map((item) => MatchRequest.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
        matchInviteRequest = (snapshot.data()?['matchInviteRequest'] as List?)
                ?.map((item) => MatchRequest.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
        captain = snapshot['captain'],
        teamId = snapshot.id;

  String teamId;
  String name;
  String address;
  String district;
  String city;
  String avatarImageUrl;
  String captain;
  Map<String, bool> incoming;
  List<MatchRequest>? matchSentRequest;
  List<MatchRequest>? matchInviteRequest;
  List<String> members;
}

class MatchRequest {
  MatchRequest({
    required this.matchId,
    required this.receiverId,
    required this.senderId,
  });

  MatchRequest.fromMap(Map<String, dynamic> map)
      : matchId = map['matchId'],
        receiverId = map['receiverId'],
        senderId = map['senderId'];

  String matchId;
  String receiverId;
  String senderId;
}
