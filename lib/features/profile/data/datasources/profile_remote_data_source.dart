import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/profile/data/models/player_model.dart';
import 'package:sportifind/features/profile/data/models/stadium_owner_model.dart';

abstract interface class ProfileRemoteDataSource {
  // PLAYER
  Future<PlayerModel> getPlayer(String id);

  // STADIUM OWNER
  Future<StadiumOwnerModel> getStadiumOwner(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  /// PLAYER 

  /// GET PLAYER
  /// Get player by id
  @override
  Future<PlayerModel> getPlayer(String id) async {
    final playerDoc = await FirebaseFirestore.instance.collection('players').doc(id).get();
    if (playerDoc['role'] != 'player') {
      throw Exception('${playerDoc['name']} is not a player');
    }
    return PlayerModel.fromFirestore(playerDoc);
  }



  /// STADIUM OWNER
  
  /// GET STADIUM OWNER
  /// Get stadium owner by id
  @override
  Future<StadiumOwnerModel> getStadiumOwner(String id) async {
    final stadiumOwnerDoc = await FirebaseFirestore.instance.collection('stadiumOwners').doc(id).get();
    if (stadiumOwnerDoc['role'] != 'stadium_owner') {
      throw Exception('${stadiumOwnerDoc['name']} is not a stadium owner');
    }
    return StadiumOwnerModel.fromFirestore(stadiumOwnerDoc);
  }

}
