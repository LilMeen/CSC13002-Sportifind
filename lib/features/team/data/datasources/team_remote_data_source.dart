
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/features/team/data/models/team_model.dart';

abstract interface class TeamRemoteDataSource {
  Future<void> createTeam(TeamModel team);
  Future<List<TeamModel>> getAllTeams();
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
    final teamRef = await FirebaseFirestore.instance.collection('teams').add(team.toFirestore());

    List<File> images = [];
    for (var image in team.images) {
      images.add(File(image));
    }
    await uploadAvatar(File(team.avatarImage), teamRef.id);
    await uploadImages(images, teamRef.id);

    final userRef = FirebaseFirestore.instance.collection('users').doc(team.captain);
    userRef.update({
      'joinedTeams': FieldValue.arrayUnion([teamRef.id]),
    });
  }


  /// GET ALL TEAMS
  /// Get all teams
  @override
  Future<List<TeamModel>> getAllTeams() async {
    QuerySnapshot teamDocs = await FirebaseFirestore.instance.collection('teams').get();
    return teamDocs.docs.map((doc) => TeamModel.fromFirestore(doc)).toList();
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
    List<File> images = [];
    for (var image in team.images) {
      images.add(File(image));
    }
    await uploadAvatar(File(team.avatarImage), team.id);
    await uploadImages(images, team.id);
  }


  /// DELETE TEAM
  /// Delete a team
  @override
  Future<void> deleteTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).delete();
  }


  // PRIVATE METHODS
  Future<void> uploadAvatar(File avatar, String teamId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('teams')
          .child(teamId)
          .child('avatar')
          .child('avatar.jpg');
      await storageRef.putFile(avatar);
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update({'avatarImage': imageUrl});
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  Future<void> uploadImages(List<File> images, String teamId) async {
    try {
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('teams')
            .child(teamId)
            .child('images')
            .child('image_$i.jpg');

        await storageRef.putFile(images[i]);
        final imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update({'images': imageUrls});
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }
}
