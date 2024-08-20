// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/notification/data/models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void>                                              updateNotificationAsRead(NotificationModel notificationData);
  Future<List<NotificationModel>>                           getNotificationData();
  Future<List<CollectionReference<Map<String, dynamic>>>>   getTeamNotificationCollectionList(String teamId);
  CollectionReference                                       getUserNotificationCollection(userId);
  Future<DocumentSnapshot<Map<String, dynamic>>>            getUserDocInformation(userId);
  Future<DocumentSnapshot<Map<String, dynamic>>>            getTeamDocInformation(teamId);

  Future<void>                                              inviteMatchRequest(senderId, receiverId, matchId);
  Future<void>                                              joinMatchRequest(senderId, receiverId, matchId);
  Future<void>                                              matchRequestAccepted(senderId, receiverId, matchId);
  Future<void>                                              matchRequestDenied(senderId, receiverId, matchId);
  
  Future<void>                                              sendUserRequest(userId, teamId);
  Future<void>                                              sendTeamRequest(userId, teamId);
  Future<void>                                              requestAccepted(userId, teamId);
  Future<void>                                              requestDeniedFromTeam(userId, teamId);
  Future<void>                                              requestDeniedFromUser(userId, teamId);

  Future<void>                                              removePlayerFromTeam(userId, teamId, type);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Future<void> updateNotificationAsRead(
      NotificationModel notificationData) async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance
        .collection('users')
        .doc(user.uid)
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
        .doc(user.uid)
        .collection('notifications')
        .get();
    final notifications = notificationQuery.docs
        .map((notification) => NotificationModel.fromFirestore(notification))
        .toList();
    for (var i = 0; i < notifications.length; ++i) {
      userNotification.add(notifications[i]);
    }
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
      throw('Error: $e');
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
      throw('Error: $e');
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
      throw('Error: $e');
    }
  }

  @override
  Future<void> matchRequestAccepted(senderId, receiverId, matchId) async {
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
      throw('Error here: $e');
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
      throw('Error: $e');
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

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message.
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
      throw('Error: $e');
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
      throw('Error: $e');
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
      throw('Error: $e');
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
        'type': 'request', // invite request, sent request, evaluate, announce, message, accepted request
        'status': 'denied',
        'senderType': 'team', // player, admin, stadium owner, team
        'sender': teamName, // username
        'receiver': userName,
        'time': Timestamp.now(), // time to sort
        'isRead': false,
      });
    } catch (e) {
      throw('Error: $e');
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
      throw('Error: $e');
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

      teamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type':
              'announce', // join request, sent request, evaluate, announce, message, accepted request
          'status': 'delete',
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
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': teamName, // username
          'receiver': 'you',
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      }
    } catch (e) {
      throw('Error: $e');
    }
  }
}