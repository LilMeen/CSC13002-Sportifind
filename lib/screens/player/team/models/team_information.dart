import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';

class TeamInformation {
  TeamInformation({
    required this.teamId,
    required this.name,
    required this.location,
    required this.avatarImageUrl,
    required this.members,
    required this.incoming,
    this.matchSentRequest,
    this.matchInviteRequest,
    required this.captain,
    required this.foundedDate,
    required this.images,
  });

  TeamInformation.empty()
      : teamId = '',
        name = '',
        location = LocationInfo(),
        avatarImageUrl = '',
        images = [],
        incoming = {},
        matchSentRequest = [],
        matchInviteRequest = [],
        members = [],
        captain = '',
        foundedDate = DateTime.now();

  factory TeamInformation.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final location = LocationInfo(
      city: data['city'],
      district: data['district'],
      address: data['address'],
    );

    return TeamInformation(
      name: data['name'],
      location: location,
      avatarImageUrl: data['avatarImage'],
      incoming: Map<String, bool>.from(data['incomingMatch']),
      members: (data['members'] as List)
          .map((item) => item.trim() as String)
          .toList(),
      matchSentRequest: (data['matchSentRequest'] as List?)
              ?.map(
                  (item) => MatchRequest.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      matchInviteRequest: (data['matchInviteRequest'] as List?)
              ?.map(
                  (item) => MatchRequest.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      captain: data['captain'],
      teamId: snapshot.id,
      foundedDate: (data['foundedDate'] as Timestamp).toDate(),
      images: List<String>.from(data['images']),
    );
  }

  String teamId;
  String name;
  LocationInfo location;
  String avatarImageUrl;
  List<String> images; 
  String captain;
  Map<String, bool> incoming;
  List<MatchRequest>? matchSentRequest;
  List<MatchRequest>? matchInviteRequest;
  List<String> members;
  DateTime foundedDate;
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
