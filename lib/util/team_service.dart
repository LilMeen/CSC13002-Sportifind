import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/screens/player/team/models/player_information.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/widgets/my_teams_listview.dart';

class TeamService {
  TeamInformation? teamInformation;
  PlayerInformation? playerInformation;
  bool isLoading = true;

  Future<List<TeamInformation>> getTeamData() async {
    try {
      final teamsQuery =
          await FirebaseFirestore.instance.collection('teams').get();
      final teamFutures = teamsQuery.docs
          .map((team) => TeamInformation.fromSnapshot(team))
          .toList();

      return teamFutures;
    } catch (error) {
      throw Exception('Failed to load stadiums data: $error');
    }
  }

  Future<TeamInformation?> getTeamInformation(String teamId) async {
    try {
      // Reference to the specific team document
      DocumentReference<Map<String, dynamic>> teamRef =
          FirebaseFirestore.instance.collection('teams').doc(teamId);

      // Get the document
      DocumentSnapshot<Map<String, dynamic>> teamSnapshot = await teamRef.get();

      // Check if the document exists
      if (teamSnapshot.exists) {
        // Use the fromSnapshot constructor to create a TeamInformation object
        TeamInformation teamInformation =
            TeamInformation.fromSnapshot(teamSnapshot);
        return teamInformation;
      } else {
        print('No such team document exists!');
        return null;
      }
    } catch (e) {
      print('Error getting team information: $e');
      return null;
    }
  }

  Future<Map<String, String>> generateTeamIdMap() async {
    final teamData = await getTeamData();
    final teamMap = {for (var team in teamData) team.name: team.teamId};
    return teamMap;
  }

  Future<Map<String, String>> generateTeamNameMap() async {
    final teamData = await getTeamData();
    final teamMap = {for (var team in teamData) team.teamId: team.name};
    return teamMap;
  }
}
