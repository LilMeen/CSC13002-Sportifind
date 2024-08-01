import 'package:cloud_firestore/cloud_firestore.dart';

class InviteJoinService {
  DocumentReference<Map<String, dynamic>> getUserDoc(userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  DocumentReference<Map<String, dynamic>> getTeamDoc(teamId) {
    return FirebaseFirestore.instance.collection('teams').doc(teamId);
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

  Future<void> sendUserRequest(userId, teamId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getUserDocInformation(userId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      await userDoc.update({
        'sentRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'joinRequest': FieldValue.arrayUnion(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message, request
          'status': 'join',
          'senderType': 'player', // player, admin, stadium owner, team
          'sender': userName, // username
          'receiver': teamName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
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
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> sendTeamRequest(userId, teamId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);
      CollectionReference userNoti = getUserNotificationCollection(userId);

      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getUserDocInformation(userId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      await userDoc.update({
        'inviteRequest': FieldValue.arrayUnion(teamId),
      });

      await teamDoc.update({
        'sentRequest': FieldValue.arrayUnion(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'sent',
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
        'senderType': 'team', // player, admin, stadium owner,
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> requestAccepted(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getUserDocInformation(userId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

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
        'joinRequest': FieldValue.arrayRemove(userId),
        'sentRequest': FieldValue.arrayRemove(userId)
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message
          'status': 'accepted',
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
        'senderType': 'player', // player, admin, stadium owner, team
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> requestDeniedFromTeam(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getUserDocInformation(userId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      await userDoc.update({
        'sentRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'joinRequest': FieldValue.arrayRemove(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'eject',
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
      print('error: $e');
    }
  }

  Future<void> requestDeniedFromUser(teamId, userId) async {
    try {
      DocumentReference<Map<String, dynamic>> userDoc = getUserDoc(userId);
      DocumentReference<Map<String, dynamic>> teamDoc = getTeamDoc(teamId);

      CollectionReference userNoti = getUserNotificationCollection(userId);
      List<CollectionReference<Map<String, dynamic>>> teamMembersNoti =
          await getTeamNotificationCollectionList(teamId);

      DocumentSnapshot<Map<String, dynamic>> userInformation =
          await getUserDocInformation(userId);
      DocumentSnapshot<Map<String, dynamic>> teamInformation =
          await getUserDocInformation(userId);

      String userName = userInformation.data()?['name'] ?? 'Unknow';
      String teamName = teamInformation.data()?['name'] ?? 'Unknow';

      await userDoc.update({
        'inviteRequest': FieldValue.arrayRemove(teamId),
      });

      await teamDoc.update({
        'sentRequest': FieldValue.arrayRemove(userId),
      });

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'request', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'denied',
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
        'status': 'eject',
        'senderType': 'user', // player, admin, stadium owner, team
        'sender': userName, // username
        'receiver': teamName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      print('error: $e');
    }
  }
}