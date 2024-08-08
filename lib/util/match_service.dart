import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';

class MatchService {
  final user = FirebaseAuth.instance.currentUser!;
  UserService userService = UserService();
  StadiumService stadiumService = StadiumService();
  TeamService teamService = TeamService();
  final hourFormat = DateFormat('HH:mm');
  final dateFormat = DateFormat('MM/dd/yyyy');

  DateTime convertStringToDateTime(String timeString, String selectedDate) {
    final time = hourFormat.parse(timeString);
    final date = dateFormat.parse(selectedDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<MatchCard?> getMatchInformation(String matchId) async {
    try {
      // Reference to the specific team document
      DocumentReference<Map<String, dynamic>> matchRef =
          FirebaseFirestore.instance.collection('matches').doc(matchId);

      // Get the document
      DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
          await matchRef.get();

      // Check if the document exists
      if (matchSnapshot.exists) {
        // Use the fromSnapshot constructor to create a TeamInformation object
        MatchCard matchInfo = MatchCard.fromSnapshot(matchSnapshot);
        return matchInfo;
      } else {
        print('No such team document exists!');
        return null;
      }
    } catch (e) {
      print('Error getting match information: $e');
      return null;
    }
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

  Future<List<MatchCard>> getMatchDataByStadiumId(String stadiumId) async {
    try {
      final matchesQuery = await FirebaseFirestore.instance
          .collection('matches')
          .where('stadium', isEqualTo: stadiumId)
          .get();
      return matchesQuery.docs
          .map((match) => MatchCard.fromSnapshot(match))
          .toList();
    } catch (error) {
      throw Exception('Failed to load matches data by stadium id: $error');
    }
  }

  Future<void> deleteMatch(String matchId) async {
    final TeamService teamService = TeamService();
    final UserService userService = UserService();
    try {
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .delete();

      await teamService.updateTeamsForMatchDelete(matchId);
      await userService.updatePlayerUsersForMatchDelete(matchId);
    } catch (error) {
      throw Exception('Failed to delete match: $error');
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

      final Map<String, dynamic> incoming =
          teamQuery.data()?['incomingMatch'] ?? {};
      print(incoming.keys.toList());
      matchesId.addAll(incoming.keys.toList());
    }

    // Retrieve match data
    for (var matchId in matchesId) {
      final matchDoc = await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get();
      if (matchDoc.exists) {
        MatchCard match = MatchCard.fromSnapshot(matchDoc);
        try {
          // Parse the match date
          final DateTime matchDate = dateFormat.parse(match.date);
          // Compare with the current date
          if (matchDate.day >= DateTime.now().day &&
              matchDate.month >= DateTime.now().month &&
              matchDate.year >= DateTime.now().year) {
            userMatches.add(match);
          }
        } catch (e) {
          print('Error parsing date for match $matchId: $e');
        }
      }
    }
    print("UserMatches");
    print(userMatches);
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
        try {
          // Parse the match date
          final DateTime matchDate = dateFormat.parse(match.date);

          if (matchDate.day == DateTime.now().day &&
              matchDate.month == DateTime.now().month &&
              matchDate.year == DateTime.now().year) {
            userMatches.add(match);
          }
        } catch (e) {
          print('Error parsing date for match $match: $e');
        }
      }
    }
    return userMatches;
  }

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');

    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
