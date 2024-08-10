
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';

abstract interface class TeamRemoteDataSource {
  Future<TeamModel> getTeam(String id);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  /// GET TEAM
  /// Get a team by its id
  @override
  Future<TeamModel> getTeam(String id) async {
    DocumentSnapshot teamDoc = await FirebaseFirestore.instance.collection('teams').doc(id).get();
    return TeamModel.fromFirestore(teamDoc);
  }
}
