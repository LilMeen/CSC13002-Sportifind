import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/util/object_handling.dart';

class Notification {
  final ObjectHandling objectHandling = ObjectHandling();

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

  // match notification
  Future<void> inviteMatchRequest(senderId, receiverId) async {
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

      senderTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match sent',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match invite',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> joinMatchRequest(senderId, receiverId) async {
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

      senderTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match sent',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match join',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> matchRequestAccepted(senderId, receiverId) async {
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

      senderTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match accepted',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match accepted',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> matchRequestDenied(senderId, receiverId) async {
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

      senderTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match denied',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });

      receiverTeamMembersNoti.map((memberNoti) async {
        await memberNoti.add({
          'type': 'request', // request, evaluate, announce, message
          'status': 'match ejected',
          'senderType': 'team', // player, admin, stadium owner, team
          'sender': senderName, // username
          'receiver': receiverName,
          'time': Timestamp.now(), // time to sort
          'isRead': false,
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Team notification
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
      print('Error: $e');
    }
  }

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
      print('Error: $e');
    }
  }

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
      print('Error: $e');
    }
  }

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
      print('Error: $e');
    }
  }

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
      print('Error: $e');
    }
  }
}
