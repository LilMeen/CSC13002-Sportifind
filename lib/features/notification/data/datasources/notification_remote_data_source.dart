// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/notification/data/models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  DocumentReference<Map<String, dynamic>> getMatchDoc(matchId);
  DocumentReference<Map<String, dynamic>> getUserDoc(userId);
  DocumentReference<Map<String, dynamic>> getTeamDoc(teamId);

  Future<void> updateNotificationAsRead(NotificationModel notificationData);
  Future<List<NotificationModel>> getNotificationData();
  Future<List<CollectionReference<Map<String, dynamic>>>>
      getTeamNotificationCollectionList(String teamId);
  CollectionReference getUserNotificationCollection(userId);
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocInformation(userId);
  Future<DocumentSnapshot<Map<String, dynamic>>> getTeamDocInformation(teamId);

  Future<void> inviteMatchRequest(senderId, receiverId, matchId);
  Future<void> joinMatchRequest(senderId, receiverId, matchId);
  Future<void> matchRequestAccepted(senderId, receiverId, matchId, status);
  Future<void> matchRequestDenied(senderId, receiverId, matchId);

  Future<void> sendUserRequest(userId, teamId);
  Future<void> sendTeamRequest(userId, teamId);
  Future<void> requestAccepted(userId, teamId);
  Future<void> requestDeniedFromTeam(userId, teamId);
  Future<void> requestDeniedFromUser(userId, teamId);

  Future<void> removePlayerFromTeam(userId, teamId, type);
  Future<void> deleteMatch(senderId, matchId);
  Future<void> deleteTeam(userId, teamId, type);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  DocumentReference<Map<String, dynamic>> getUserDoc(userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  @override
  DocumentReference<Map<String, dynamic>> getTeamDoc(teamId) {
    return FirebaseFirestore.instance.collection('teams').doc(teamId);
  }

  @override
  DocumentReference<Map<String, dynamic>> getMatchDoc(matchId) {
    return FirebaseFirestore.instance.collection('matches').doc(matchId);
  }

  @override
  Future<void> updateNotificationAsRead(
      NotificationModel notificationData) async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .doc(notificationData
            .id) // Assuming your NotificationData has an 'id' field
        .update({'isRead': true});
  }

  @override
  Future<List<NotificationModel>> getNotificationData() async {
    List<NotificationModel> userNotification = [];
    final notificationQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notifications')
        .get();
    final notifications = notificationQuery.docs
        .map((notification) => NotificationModel.fromFirestore(notification))
        .toList();
    for (var i = 0; i < notifications.length; ++i) {
      userNotification.add(notifications[i]);
    }
    userNotification.sort((a, b) => a.time.compareTo(b.time));
    return userNotification;
  }

  @override
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
      throw ('Error: $e');
    }
  }

  @override
  CollectionReference getUserNotificationCollection(userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications');
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocInformation(userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getTeamDocInformation(teamId) {
    return FirebaseFirestore.instance.collection('teams').doc(teamId).get();
  }

  // match notification
  @override
  Future<void> inviteMatchRequest(senderId, receiverId, matchId) async {
    try {
      List<CollectionReference<Map<String, dynamic>>> senderTeamMembersNoti =
          await getTeamNotificationCollectionList(senderId);

      List<CollectionReference<Map<String, dynamic>>> receiverTeamMembersNoti =
          await getTeamNotificationCollectionList(receiverId);

      DocumentSnapshot<Map<String, dynamic>> senderInformation =
          await getTeamDocInformation(senderId);
      DocumentSnapshot<Map<String, dynamic>> receiverInformation =
          await getTeamDocInformation(receiverId);

      String senderName = senderInformation.data()?['name'] ?? 'Unknow';
      String receiverName = receiverInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);

      //// big note here
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

      senderTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match sent',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match invite',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> joinMatchRequest(senderId, receiverId, matchId) async {
    try {
      List<CollectionReference<Map<String, dynamic>>> senderTeamMembersNoti =
          await getTeamNotificationCollectionList(senderId);

      List<CollectionReference<Map<String, dynamic>>> receiverTeamMembersNoti =
          await getTeamNotificationCollectionList(receiverId);

      DocumentSnapshot<Map<String, dynamic>> senderInformation =
          await getTeamDocInformation(senderId);
      DocumentSnapshot<Map<String, dynamic>> receiverInformation =
          await getTeamDocInformation(receiverId);

      String senderName = senderInformation.data()?['name'] ?? 'Unknow';
      String receiverName = receiverInformation.data()?['name'] ?? 'Unknow';

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

      senderTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match sent',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match join',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
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
          throw ("This match has already contains second team");
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
            'team2': receiverId,
          });
        } else {
          throw ("This match has already contains second team");
        }
      }

      // NOTIFICATION PART
      List<CollectionReference<Map<String, dynamic>>> senderTeamMembersNoti =
          await getTeamNotificationCollectionList(senderId);

      List<CollectionReference<Map<String, dynamic>>> receiverTeamMembersNoti =
          await getTeamNotificationCollectionList(receiverId);

      String senderName = senderInformation.data()?['name'] ?? 'Unknow';
      String receiverName = receiverInformation.data()?['name'] ?? 'Unknow';

      senderTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match accepted',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match accepted',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      throw ('error: $e');
    }
  }

  @override
  Future<void> matchRequestDenied(senderId, receiverId, matchId) async {
    try {
      List<CollectionReference<Map<String, dynamic>>> senderTeamMembersNoti =
          await getTeamNotificationCollectionList(senderId);

      List<CollectionReference<Map<String, dynamic>>> receiverTeamMembersNoti =
          await getTeamNotificationCollectionList(receiverId);
      DocumentSnapshot<Map<String, dynamic>> senderInformation =
          await getTeamDocInformation(senderId);
      DocumentSnapshot<Map<String, dynamic>> receiverInformation =
          await getTeamDocInformation(receiverId);

      String senderName = senderInformation.data()?['name'] ?? 'Unknow';
      String receiverName = receiverInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> senderDoc = getTeamDoc(senderId);
      DocumentReference<Map<String, dynamic>> receiverDoc =
          getTeamDoc(receiverId);
      //DocumentReference<Map<String, dynamic>> matchDoc = getMatchDoc(matchId);

      Map<String, String> matchInfo = {
        'matchId': matchId,
        'senderId': receiverId,
        'receiverId': senderId,
      };

      await receiverDoc.update({
        'matchSentRequest': FieldValue.arrayRemove([matchInfo]),
        'matchJoinRequest': FieldValue.arrayRemove([matchInfo]),
      });

      await senderDoc.update({
        'matchInviteRequest': FieldValue.arrayRemove([matchInfo]),
        'joinMatchRequest': FieldValue.arrayRemove([matchInfo]),
      });
      senderTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match denied',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match rejected',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  // Team notification
  @override
  Future<void> sendUserRequest(userId, teamId) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'sentRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'joinRequestsFromPlayers': FieldValue.arrayUnion(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message.
          'status': 'join',
          'senderType': 'player', // player, admin, stadium owner, team
          'sender': userName, // username
          'receiver': teamName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
          'match': '',
        });
      });

      await userNoti.add({
        'type':
            'request', // invite request, sent request, evaluate, announce, message, accepted request
        'status': 'sent',
        'senderType': 'player', // player, admin, stadium owner, team
        'sender': userName, // username
        'receiver': teamName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
        'match': '',
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> sendTeamRequest(userId, teamId) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);

      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'inviteRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'invitedPlayers': FieldValue.arrayUnion(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'sent',
          'match': '',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': userName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      await userNoti.add({
        'type': 'request', // request, evaluate, announce, message
        'status': 'invite',
        'match': '',
        'senderType': 'team', // player, admin, stadium owner,
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> requestAccepted(userId, teamId) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

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
        'joinRequestsFromPlayers': FieldValue.arrayRemove(userId),
        'invitedPlayers': FieldValue.arrayRemove(userId)
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message
          'status': 'accepted',
          'match': '',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': userName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      await userNoti.add({
        'type':
            'request', // invite request, sent request, evaluate, announce, message
        'status': 'accepted',
        'match': '',
        'senderType': 'player', // player, admin, stadium owner, team
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> requestDeniedFromTeam(userId, teamId) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'sentRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'joinRequestsFromPlayers': FieldValue.arrayRemove(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'rejected',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': userName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      await userNoti.add({
        'type':
            'request', // invite request, sent request, evaluate, announce, message, accepted request
        'status': 'denied',
        'senderType': 'team', // player, admin, stadium owner, team
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> requestDeniedFromUser(userId, teamId) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'inviteRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'invitedPlayers': FieldValue.arrayRemove(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'denied',
          'match': '',
          'senderType': 'user', // player, admin, stadium owner, team
          'sender': userName, // username
          'receiver': teamName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      await userNoti.add({
        'type':
            'request', // invite request, sent request, evaluate, announce, message, accepted request
        'status': 'rejected',
        'match': '',
        'senderType': 'user', // player, admin, stadium owner, team
        'sender': userName, // username
        'receiver': teamName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> removePlayerFromTeam(userId, teamId, type) async {
    try {
      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      await userDoc.update({
        'joinedTeams': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'members': FieldValue.arrayRemove(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'announce', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'delete',
          'match': '',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': userName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      if (type == 'kicked') {
        await userNoti.add({
          'type':
              'announce', // invite request, sent request, evaluate, announce, message, accepted request
          'status': 'kicked',
          'match': '',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': 'you',
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      } else if (type == 'left') {
        await userNoti.add({
          'type':
              'announce', // invite request, sent request, evaluate, announce, message, accepted request
          'status': 'left',
          'match': '',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': 'you',
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      }
    } catch (e) {
      throw ('Error: $e');
    }
  }

  @override
  Future<void> deleteTeam(userId, teamId, type) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getTeamDocInformation(teamId);

      List<String>? members =
          List<String>.from(teamInformation.data()?['members'] ?? []);

      members.forEach((memberId) async {
        CollectionReference userNoti = getUserNotificationCollection(memberId);
        DocumentSnapshot<Map<String, dynamic>> userInformation =
            await getUserDocInformation(memberId);
        String userName = userInformation.data()?['name'] ?? 'Unknow';

        // hoi thanh cho delete match

        await userNoti.add({
          'type':
              'announce', // invite request, sent request, evaluate, announce, message, accepted request
          'status': 'delete',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamInformation.data()?['name'] ?? 'Unknow', // username
          'receiver': userName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
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
      throw ('Error: $e');
    }
  }

  @override
  Future<void> deleteMatch(senderId, matchId) async {
    try {
      List<CollectionReference<Map<String, dynamic>>> senderTeamMembersNoti =
          await getTeamNotificationCollectionList(senderId);

      DocumentSnapshot<Map<String, dynamic>> senderInformation =
          await getTeamDocInformation(senderId);

      String senderName = senderInformation.data()?['name'] ?? 'Unknow';

      senderTeamMembersNoti.forEach((memberNoti) async {
        await memberNoti.add({
          'type': 'annouce', // request, evaluate, announce, message
          'status': 'match deleted',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': 'you',
          'match': matchId,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      await getMatchDoc(matchId).delete();
    } catch (e) {
      throw ('Error: $e');
    }
  }
}
