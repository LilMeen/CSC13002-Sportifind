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
}
