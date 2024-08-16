import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/match/data/models/match_model.dart';

abstract interface class MatchRemoteDataSource {
  Future<void> createMatch(MatchModel match);
  Future<MatchModel> getMatch(String id);
  Future<List<MatchModel>> getAllMatches();
  Future<List<MatchModel>> getMatchesByStadium(String stadiumId);
  Future<List<MatchModel>> getMatchesByTeam(String teamId);

  Future<void> deleteMatch(String id);

  Future<void> sendRequestToJoinMatch(String teamSendId, String teamReceiveId, String matchId);
  Future<void> sendInvitationToMatch(String teamSendId, String teamReceiveId, String matchId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  // CREATE MATCH
  // Create a new match
  @override
  Future<void> createMatch(MatchModel match) async {
    final matchRef = await FirebaseFirestore.instance.collection('matches').add(
      match.toFirestore(),
    );
    await FirebaseFirestore.instance.collection('teams').doc(match.team1Id).update({
      'incomingMatch.${matchRef.id}': false,
    });
  }

  /// GET MATCH
  /// Get match by id
  @override
  Future<MatchModel> getMatch(String id) async {
    final matchDoc = await FirebaseFirestore.instance.collection('matches').doc(id).get();
    return MatchModel.fromFirestore(matchDoc);
  }


  /// GET ALL MATCHES
  /// Get all matches
  @override
  Future<List<MatchModel>> getAllMatches() async {
    final matches = await FirebaseFirestore.instance.collection('matches').get();
    return matches.docs.map((doc) => MatchModel.fromFirestore(doc)).toList();
  }


  /// GET MATCHES BY STADIUM
  /// Get matches by stadium id
  @override
  Future<List<MatchModel>> getMatchesByStadium(String stadiumId) async {
    final matches = await FirebaseFirestore.instance.collection('matches').where('stadium', isEqualTo: stadiumId).get();
    return matches.docs.map((doc) => MatchModel.fromFirestore(doc)).toList();
  }


  /// GET MATCHES BY TEAM
  /// Get matches by team id
  @override
  Future<List<MatchModel>> getMatchesByTeam(String teamId) async {
    final incomingMatch = await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamId)
      .get().then((doc) => doc.data()!['incomingMatch']);
    List<MatchModel> matches = [];
    for (var matchId in incomingMatch.keys) {
      final match = await FirebaseFirestore.instance.collection('matches').doc(matchId).get();
      if (!match.exists) {
        continue;
      }
      matches.add(MatchModel.fromFirestore(match));
    }
    return matches;
  }


  /// DELETE MATCH
  /// Delete match by id
  @override
  Future<void> deleteMatch(String id) async {
    await FirebaseFirestore.instance.collection('matches').doc(id).delete();
  }


  /// SEND REQUEST TO JOIN MATCH
  /// Send request to join match
  @override
  Future<void> sendRequestToJoinMatch(String teamSendId, String teamReceiveId, String matchId) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = FirebaseFirestore.instance.collection('teams').doc(teamSendId);
      DocumentReference<Map<String, dynamic>> receiverDoc = FirebaseFirestore.instance.collection('teams').doc(teamReceiveId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': teamSendId,
        'receiverId': teamReceiveId,
      };

      await senderDoc.update({
        'matchJoinRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await receiverDoc.update({
        'joinMatchRequest': FieldValue.arrayUnion([matchInfo]),
      });
    } catch (e) {
      throw('error: $e');
    }
  }


  /// SEND INVITATION TO MATCH
  /// Send invitation to match
  @override
  Future<void> sendInvitationToMatch(String teamSendId, String teamReceiveId, String matchId) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = FirebaseFirestore.instance.collection('teams').doc(teamSendId);
      DocumentReference<Map<String, dynamic>> receiverDoc = FirebaseFirestore.instance.collection('teams').doc(teamReceiveId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': teamSendId,
        'receiverId': teamReceiveId,
      };

      await senderDoc.update({
        'matchSentRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await receiverDoc.update({
        'matchInviteRequest': FieldValue.arrayUnion([matchInfo]),
      });
    } catch (e) {
      throw('error: $e');
    }
  }
}