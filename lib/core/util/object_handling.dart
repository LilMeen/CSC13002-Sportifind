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

      await notification.inviteMatchRequest(senderId, receiverId);
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

      await notification.joinMatchRequest(senderId, receiverId);
    } catch (e) {
      print('error: $e');
    }
  }

  // match accepted (mai sua lai)
  Future<void> matchRequestAccepted(senderId, receiverId, matchId) async {
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
        'senderId': senderId,
        'receiverId': receiverId,
      };

      Map<String, dynamic> incomingMatchMap = receiverInformation.get('incomingMatch');
      if (incomingMatchMap.containsKey(matchId)) {
        incomingMatchMap[matchId] = true;
      }

      await senderDoc.update({
        'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
        'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
        'incomingMatch': incomingMatchMap,
      });

      final Map<String, bool> newMatch = {matchId: true};

      await receiverDoc.update({
        'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
        'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
        'incomingMatch': newMatch,
      });

      await matchDoc.update({
        'team2': senderId,
        'team2_avatar': senderInformation.data()?['avatarImage'] ?? '',
      });

      notification.matchRequestAccepted(senderId, receiverId);
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
      DocumentReference<Map<String, dynamic>> matchDoc = getMatchDoc(matchId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': senderId,
        'receiverId': receiverId,
      };

      await senderDoc.update({
        'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
        'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
      });

      await receiverDoc.update({
        'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
        'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
      });

      notification.matchRequestDenied(senderId, receiverId);
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
}
