import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';

class MatchService {
  final user = FirebaseAuth.instance.currentUser!;
  UserService userService = UserService();
  StadiumService stadiumService = StadiumService();
  TeamService teamService = TeamService();

  DateTime convertStringToDateTime(String timeString, String selectedDate) {
    final hourFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('M/D/yyyy');
    final time = hourFormat.parse(timeString);
    final date = dateFormat.parse(selectedDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Function for fetching data from firestore
  Future<void> getMatchData(List<MatchCard> userMatches) async {
    final matchesQuery =
        await FirebaseFirestore.instance.collection('matches').get();
    final matches = matchesQuery.docs
        .map((match) => MatchCard.fromSnapshot(match))
        .toList();
    for (var i = 0; i < matches.length; ++i) {
      userMatches.add(matches[i]);
    }
  }

  // Function for parsing data
  Future<void> getMatchDate(
      DateTime selectedDate,
      String selectedField,
      String selectedStadiumId,
      List<MatchCard> userMatches,
      List<DateTimeRange> bookedSlot) async {
    bookedSlot.clear();
    userMatches.clear();
    final String date = formatter.format(selectedDate);

    await getMatchData(userMatches);
    for (var i = 0; i < userMatches.length; i++) {
      final String matchDate = userMatches[i].date;
      print(selectedField);
      print(userMatches[i].field);
      if (date == matchDate &&
          selectedField == userMatches[i].field &&
          selectedStadiumId == userMatches[i].stadium) {
        bookedSlot.add(DateTimeRange(
            start: convertStringToDateTime(
                userMatches[i].start, userMatches[i].date),
            end: convertStringToDateTime(
                userMatches[i].end, userMatches[i].date)));
      }
    }
    userMatches.clear();
  }

  Future<List<TeamInformation>> getTeamData() async {
    List<TeamInformation> team = [];
    final teamQuery =
        await FirebaseFirestore.instance.collection('teams').get();
    final teams = teamQuery.docs
        .map((match) => TeamInformation.fromSnapshot(match))
        .toList();
    for (var i = 0; i < teams.length; ++i) {
      if (teams[i].captain == user.uid) {
        team.add(teams[i]);
      }
    }
    return team;
  }

  Future<List<MatchCard>> getPersonalMatchData() async {
    final List<MatchCard> userMatches = [];
    List<String> matchesId = [];
    final PlayerData user = await userService.getUserPlayerData();

    // Retrieve matches for user's teams
    for (var teamId in user.teams) {
      final teamQuery = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .get();

      final Map<String, dynamic> incoming = teamQuery.data()?['incoming'] ?? {};
      matchesId.addAll(incoming.keys.toList());
      print("-------------------------");
      print(matchesId);
    }

    // Retrieve match data
    for (var matchId in matchesId) {
      final matchDoc = await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get();
      if (matchDoc.exists) {
        MatchCard match = MatchCard.fromSnapshot(matchDoc);
        match = await convertStadiumIdToName(match);
        userMatches.add(match);
      }
    }
    return userMatches;
  }

  bool checkDifferentTeam(PlayerData userTeam, MatchCard userMatch) {
    for (var i = 0; i < userTeam.teams.length; ++i) {
      if (userTeam.teams[i] == userMatch.team1) {
        return false;
      }
    }
    return true;
  }

  Future<List<MatchCard>> getNearbyMatchData(List<StadiumData> stadiums) async {
    final List<MatchCard> userMatches = [];
    final PlayerData user = await userService.getUserPlayerData();

    // Retrieve all match documents
    final matchesQuery =
        await FirebaseFirestore.instance.collection('matches').get();
    final matches = matchesQuery.docs
        .map((match) => MatchCard.fromSnapshot(match))
        .toList();

    for (var match in matches) {
      if (checkDifferentTeam(user, match)) {
        userMatches.add(match);
      }
    }
    return userMatches;
  }

  Future<Map<String, String>> generateStadiumMap() async {
    final stadiumData = await stadiumService.getStadiumsData();
    final stadiumMap = {
      for (var stadium in stadiumData) stadium.id: stadium.name
    };
    return stadiumMap;
  }

  Future<MatchCard> convertStadiumIdToName(MatchCard match) async {
    final stadiumMap = await generateStadiumMap();
    match.stadium = stadiumMap[match.stadium] ?? 'Unknown Stadium';
    return match;
  }

  Future<Map<String, String>> generateTeamMap() async {
    final teamData = await teamService.getTeamData();
    final teamMap = {for (var team in teamData) team.teamId: team.name};
    return teamMap;
  }

  Future<String> convertTeamIdToName(String teamId) async {
    final teamMap = await generateTeamMap();
    return teamMap[teamId] ?? 'Unknown Team';
  }

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');

    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }
}
