import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/player_data.dart';

class UserService {
  Future<PlayerData> getUserPlayerData() async {
    try {
      User? userFB = FirebaseAuth.instance.currentUser;
      if (userFB != null) {
        String uid = userFB.uid;
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          return PlayerData.fromSnapshot(snapshot);
        }
      }
      throw Exception('User not found');
    } catch (error) {
      throw Exception('Failed to load user data: $error');
    }
  }

  Future<OwnerData> getUserOwnerData() async {
    try {
      User? userFB = FirebaseAuth.instance.currentUser;
      if (userFB != null) {
        String uid = userFB.uid;
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          return OwnerData.fromSnapshot(snapshot);
        }
      }
      throw Exception('User not found');
    } catch (error) {
      throw Exception('Failed to load user data: $error');
    }
  }

  Future<List<PlayerData>> getPlayerData() async {
    try {
      final playersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'player')
          .get();
      return playersQuery.docs
          .map((player) => PlayerData.fromSnapshot(player))
          .toList();
    } catch (error) {
      throw Exception('Failed to load player data: $error');
    }
  }

  Future<List<PlayerData>> getPlayersDataWithNotifications() async {
    try {
      final playersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'player')
          .get();
      final playersFutures = playersQuery.docs
          .map((player) => PlayerData.fromSnapshotAsync(player))
          .toList();
      return await Future.wait(playersFutures);
    } catch (error) {
      throw Exception('Failed to load players data with notification: $error');
    }
  }

  Future<List<OwnerData>> getOwnersData() async {
    try {
      final ownersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'stadium_owner')
          .get();
      return ownersQuery.docs
          .map((owner) => OwnerData.fromSnapshot(owner))
          .toList();
    } catch (error) {
      throw Exception('Failed to load owners data: $error');
    }
  }

  Future<Map<String, String>> generateUserMap() async {
    final userData = await getPlayerData();
    final userMap = {for (var user in userData) user.id: user.name};
    return userMap;
  }

  Future<void> updatePlayerUsersForMatchDelete(String matchId) async {
    final List<PlayerData> players = await getPlayersDataWithNotifications();
    final playerUserQuery = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'player');

    Map<String, List<String>> delPlayerNotifications = {};

    for (var player in players) {
      final delNotificationIds = player.notifications
          .where((noti) => noti.matchId == matchId)
          .map((noti) => noti.id!)
          .toList();

      if (delNotificationIds.isNotEmpty) {
        delPlayerNotifications[player.id] = delNotificationIds;
      }
    }

    final playerDocs = await playerUserQuery.get();

    for (var playerDoc in playerDocs.docs) {
      final playerId = playerDoc.id;
      if (delPlayerNotifications.containsKey(playerId)) {
        for (var notiId in delPlayerNotifications[playerId]!) {
          await playerDoc.reference
              .collection('notifications')
              .doc(notiId)
              .delete();
        }
      }
    }
  }
}
