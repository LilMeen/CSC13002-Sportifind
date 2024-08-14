import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/data/models/stadium_owner_model.dart';
import 'package:sportifind/features/user/data/models/user_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserModel> getCurrentProfile();

  // PLAYER
  Future<PlayerModel> getPlayer(String id);
  Future<List<PlayerModel>> getAllPlayers();

  // STADIUM OWNER
  Future<StadiumOwnerModel> getStadiumOwner(String id);
  Future<List<StadiumOwnerModel>> getAllStadiumOwners();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  /// GET CURRENT USER
  /// Get current user
  @override
  Future<UserModel> getCurrentProfile() async {
    final currentUserDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
    if (currentUserDoc['role'] == 'player') {
      return PlayerModel.fromFirestore(currentUserDoc);
    } else if (currentUserDoc['role'] == 'stadium_owner') {
      return StadiumOwnerModel.fromFirestore(currentUserDoc);
    } else {
      throw Exception('User role not found');
    }
  }


  /// PLAYER 

  /// GET PLAYER
  /// Get player by id
  @override
  Future<PlayerModel> getPlayer(String id) async {
    final playerDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    return PlayerModel.fromFirestore(playerDoc);
  }

  /// GET ALL PLAYERS
  /// Get all players
  @override
  Future<List<PlayerModel>> getAllPlayers() async {
    final playersDocs = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'player').get();
    return playersDocs.docs.map((playerDoc) => PlayerModel.fromFirestore(playerDoc)).toList();
  }


  /// STADIUM OWNER
  
  /// GET STADIUM OWNER
  /// Get stadium owner by id
  @override
  Future<StadiumOwnerModel> getStadiumOwner(String id) async {
    final stadiumOwnerDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get();
    if (stadiumOwnerDoc['role'] != 'stadium_owner') {
      throw Exception('${stadiumOwnerDoc['name']} is not a stadium owner');
    }
    return StadiumOwnerModel.fromFirestore(stadiumOwnerDoc);
  }

  /// GET ALL STADIUM OWNERS
  /// Get all stadium owners
  @override
  Future<List<StadiumOwnerModel>> getAllStadiumOwners() async {
    final stadiumOwnersDocs = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'stadium_owner')
      .get();
    return stadiumOwnersDocs.docs.map((stadiumOwnerDoc) => StadiumOwnerModel.fromFirestore(stadiumOwnerDoc)).toList();
  }

}
