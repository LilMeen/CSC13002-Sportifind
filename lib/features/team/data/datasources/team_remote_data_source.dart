
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';

abstract interface class TeamRemoteDataSource {
  Future<void> createTeam(TeamModel team);
  Future<TeamModel> getTeam(String id);
  Future<List<TeamModel>> getTeamByPlayer(String playerId);
  Future<void> updateTeam(TeamModel team);
  Future<void> deleteTeam(String teamId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  /// CREATE TEAM
  /// Create a new team
  @override
  Future<void> createTeam(TeamModel team) async {
    await FirebaseFirestore.instance.collection('teams').add(team.toFirestore());
  }


  /// GET TEAM
  /// Get a team by its id
  @override
  Future<TeamModel> getTeam(String id) async {
    DocumentSnapshot teamDoc = await FirebaseFirestore.instance.collection('teams').doc(id).get();
    return TeamModel.fromFirestore(teamDoc);
  }


  /// GET TEAM BY PLAYER
  /// Get a list of teams by player id
  @override
  Future<List<TeamModel>> getTeamByPlayer(String playerId) async {
    final user = await FirebaseFirestore.instance.collection('users').doc(playerId).get();
    List<TeamModel> teamList = [];
    for (var teamId in user.data()!['joinedTeams']) {
      DocumentSnapshot teamDoc = await FirebaseFirestore.instance.collection('teams').doc(teamId).get();
      teamList.add(TeamModel.fromFirestore(teamDoc));
    }
    return teamList;
  }


  /// UPDATE TEAM
  /// Update a team
  @override
  Future<void> updateTeam(TeamModel team) async {
    await FirebaseFirestore.instance.collection('teams').doc(team.id).update(team.toFirestore());
  }


  /// DELETE TEAM
  /// Delete a team
  @override
  Future<void> deleteTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).delete();
  }
}
