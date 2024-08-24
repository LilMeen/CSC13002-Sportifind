import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/util/notification_service.dart';

class ObjectHandling {
  NotificationService notification = NotificationService();
  DocumentReference<Map<String, dynamic>> getUserDoc(userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  DocumentReference<Map<String, dynamic>> getTeamDoc(teamId) {
    return FirebaseFirestore.instance.collection('teams').doc(teamId);
  }

  DocumentReference<Map<String, dynamic>> getMatchDoc(matchId) {
    return FirebaseFirestore.instance.collection('matches').doc(matchId);
  }

  Future<List<CollectionReference<Map<String, dynamic>>>>
      getTeamNotificationCollectionList(String teamId) async {
    try {
      // Get the team document
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      // Extract the list of member IDs
      List<String>? members =
          List<String>.from(teamInformation.data()?['members'] ?? []);

      // Create a list of CollectionReferences for each member's notifications collection
      List<CollectionReference<Map<String, dynamic>>> notificationsCollections =
          members.map((memberId) {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .collection('notifications');
      }).toList();

      return notificationsCollections;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  CollectionReference getUserNotificationCollection(userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocInformation(userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTeamDocInformation(teamId) {
    return FirebaseFirestore.instance.collection('teams').doc(teamId).get();
  }
}

class MatchHandling extends ObjectHandling {
  // sender invite receiver to match
  Future<void> inviteMatchRequest(senderId, receiverId, matchId) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': senderId,
        'receiverId': receiverId,
      };

      await senderDoc.update({
        'matchSentRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await receiverDoc.update({
        'matchInviteRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await notification.inviteMatchRequest(senderId, receiverId, matchId);
    } catch (e) {
      print('error: $e');
    }
  }

  // some team wanna join a match from suggested match list
  Future<void> joinMatchRequest(senderId, receiverId, matchId) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': senderId,
        'receiverId': receiverId,
      };

      await senderDoc.update({
        'matchJoinRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await receiverDoc.update({
        'joinMatchRequest': FieldValue.arrayUnion([matchInfo]),
      });

      await notification.joinMatchRequest(senderId, receiverId, matchId);
    } catch (e) {
      print('error: $e');
    }
  }

  // match accepted (mai sua lai)
  Future<void> matchRequestAccepted(
      senderId, receiverId, matchId, status) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);
      DocumentReference<Map<String, dynamic>> matchDoc = getMatchDoc(matchId);

      DocumentSnapshot<Map<String, dynamic>> senderInformation =
          await getTeamDocInformation(senderId);
      DocumentSnapshot<Map<String, dynamic>> receiverInformation =
          await getTeamDocInformation(receiverId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': receiverId,
        'receiverId': senderId,
      };

      if (status == 'match invite') {
        Map<String, dynamic> incomingMatchMap =
            receiverInformation.get('incomingMatch');
        if (incomingMatchMap.containsKey(matchId)) {
          incomingMatchMap[matchId] = true;
        }
        await receiverDoc.update({
          'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
          'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
          'incomingMatch': incomingMatchMap,
        });

        final Map<String, bool> newMatch = {matchId: true};

        await senderDoc.update({
          'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
          'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
          'incomingMatch': newMatch,
        });

        DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
            await matchDoc.get();
        Map<String, dynamic>? matchData = matchSnapshot.data();
        if (matchData!['team2'].isEmpty) {
          await matchDoc.update({
            'team2': senderId,
          });
        } else {
          print("This match has already contains second team");
        }
      } else if (status == "match join") {
        Map<String, dynamic> incomingMatchMap =
            senderInformation.get('incomingMatch');
        if (incomingMatchMap.containsKey(matchId)) {
          incomingMatchMap[matchId] = true;
        }
        final Map<String, bool> newMatch = {matchId: true};
        await receiverDoc.update({
          'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
          'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
          'incomingMatch': newMatch,
        });

        await senderDoc.update({
          'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
          'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
          'incomingMatch': incomingMatchMap,
        });

        DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
            await matchDoc.get();
        Map<String, dynamic>? matchData = matchSnapshot.data();
        if (matchData!['team2'].isEmpty) {
          await matchDoc.update({
            'team2': senderId,
          });
        } else {
          print("This match has already contains second team");
        }
      }

      notification.matchRequestAccepted(senderId, receiverId, matchId);
    } catch (e) {
      print('error: $e');
    }
  }

  // match denied
  Future<void> matchRequestDenied(senderId, receiverId, matchId) async {
    try {
      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);
      //DocumentReference<Map<String, dynamic>> matchDoc = getMatchDoc(matchId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': receiverId,
        'receiverId': senderId,
      };

      print(matchInfo);

      await receiverDoc.update({
        'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
        'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
      });

      await senderDoc.update({
        'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
        'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
      });

      notification.matchRequestDenied(senderId, receiverId, matchId);
    } catch (e) {
      print('error: $e');
    }
  }
}

class TeamHandling extends ObjectHandling {
  // User wanna join a team
  Future<void> sendUserRequest(userId, teamId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'sentRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'playerJoinRequest': FieldValue.arrayUnion(userId),
      });

      notification.sendUserRequest(userId, teamId);
    } catch (e) {
      print('error: $e');
    }
  }

  // Team wanna invite a user
  Future<void> sendTeamRequest(userId, teamId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'inviteRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'playerSentRequest': FieldValue.arrayUnion(userId),
      });

      notification.sendTeamRequest(userId, teamId);
    } catch (e) {
      print('error: $e');
    }
  }

  // team and user accepted the request
  Future<void> requestAccepted(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'joinedTeams': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'members': FieldValue.arrayUnion(userId),
      });

      await userDoc.update({
        'inviteRequest': FieldValue.arrayRemove(teamId),
        'sentRequest': FieldValue.arrayRemove(teamId)
      });

      await teamDoc.update({
        'playerJoinRequest': FieldValue.arrayRemove(userId),
        'playerSentRequest': FieldValue.arrayRemove(userId)
      });

      notification.requestAccepted(userId, teamId);
    } catch (e) {
      print('error: $e');
    }
  }

  // team eject user join request
  Future<void> requestDeniedFromTeam(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'sentRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'playerJoinRequest': FieldValue.arrayRemove(userId),
      });

      notification.requestDeniedFromTeam(userId, teamId);
    } catch (e) {
      print('error: $e');
    }
  }

  // user eject the invite request
  Future<void> requestDeniedFromUser(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'inviteRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'playerSentRequest': FieldValue.arrayRemove(userId),
      });

      notification.requestDeniedFromUser(userId, teamId);
    } catch (e) {
      print('error: $e');
    }
  }

  // team delete user from team
  Future<void> removePlayerFromTeam(teamId, userId, type) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'joinedTeams': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'members': FieldValue.arrayRemove(userId),
      });

      notification.removePlayerFromTeam(userId, teamId, type);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> deleteTeam(teamId) async {
    try {
      notification.deleteTeam(teamId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);
      // delete match of this team
      QuerySnapshot<Map<String, dynamic>> matchSnapshot1 =
          await FirebaseFirestore.instance
              .collection('matches')
              .where('team1', isEqualTo: teamId)
              .get();
      QuerySnapshot<Map<String, dynamic>> matchSnapshot2 =
          await FirebaseFirestore.instance
              .collection('matches')
              .where('team2', isEqualTo: teamId)
              .get();

      matchSnapshot1.docs.forEach((element) {
        element.reference.delete();
      });
      matchSnapshot2.docs.forEach((element) {
        element.reference.delete();
      });

      // delete this team id from joinedTeams of all users
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      userSnapshot.docs.forEach((element) {
        element.reference.update({
          'joinedTeams': FieldValue.arrayRemove(teamId),
        });
      });
      await teamDoc.delete();
    } catch (e) {
      print('error: $e');
    }
  }
}
