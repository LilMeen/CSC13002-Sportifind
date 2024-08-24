import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/search_service.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/widgets/my_teams_listview.dart';
import 'package:path_provider/path_provider.dart';

class TeamService {
  TeamInformation? teamInformation;
  PlayerData? playerInformation;
  SearchService searchService = SearchService();
  LocationService locationService = LocationService();
  UserService userService = UserService();
  bool isLoading = true;

  Future<Map<String, String>> generateTeamMap() async {
    final teamData = await getTeamData();
    final teamMap = {for (var team in teamData) team.teamId: team.name};
    return teamMap;
  }

  Future<String> convertTeamIdToName(String teamId) async {
    final teamMap = await generateTeamMap();
    return teamMap[teamId] ?? 'Unknown Team';
  }

  Future<List<PlayerData>> getPlayersData(List<String> teamMembers) async {
    List<PlayerData> playersData = [];
    for (var member in teamMembers) {
      PlayerData? playerData = await userService.getPlayerData(member);
      if (playerData != null) {
        playersData.add(playerData);
      }
    }
    return playersData;
  }

  Future<List<TeamInformation>> getTeamData() async {
    try {
      final teamsQuery =
          await FirebaseFirestore.instance.collection('teams').get();
      final teamFutures = teamsQuery.docs
          .map((team) => TeamInformation.fromSnapshot(team))
          .toList();

      return teamFutures;
    } catch (error) {
      throw Exception('Failed to load teams data: $error');
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

  Future<List<TeamInformation?>> getUserTeams(String userId) {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      return userRef.get().then((userSnapshot) async {
        if (userSnapshot.exists) {
          List<dynamic> userTeamsDynamic = userSnapshot['joinedTeams'] ?? [];
          List<String> userTeams =
              userTeamsDynamic.map((team) => team.toString()).toList();
          List<TeamInformation?> fetchedTeams = [];
          for (var team in userTeams) {
            final teamInformation = await getTeamInformation(team);
            fetchedTeams.add(teamInformation);
          }
          return fetchedTeams;
        } else {
          return [];
        }
      });
    } catch (e) {
      throw Exception('Error getting user teams: $e');
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

  List<TeamInformation> sortNearbyTeams(
      List<TeamInformation> teams, LocationInfo markedLocation) {
    locationService.sortByDistance<TeamInformation>(
      teams,
      markedLocation,
      (teams) => teams.location,
    );
    return teams;
  }

  List<TeamInformation> sortTeamByLocation(
      List<TeamInformation> teams, LocationInfo location) {
    // sort by district and city
    String city = location.city;
    String district = location.district;

    List<TeamInformation> sortedTeamsByCity =
        teams.where((team) => team.location.city == city).toList();

    List<TeamInformation> sortedTeamsByDistrictUpper = sortedTeamsByCity
        .where((team) => team.location.district == district)
        .toList();
    List<TeamInformation> sortedTeamByDistrictLower = sortedTeamsByCity
        .where((team) => team.location.district != district)
        .toList();

    // concatenate the two lists
    sortedTeamsByDistrictUpper.addAll(sortedTeamByDistrictLower);
    return sortedTeamsByDistrictUpper;
  }

  List<TeamInformation> performTeamSearch(List<TeamInformation> teams,
      String searchText, String selectedCity, String selectedDistrict) {
    return searchService.searchingNameAndLocation(
      listItems: teams,
      searchText: searchText,
      selectedCity: selectedCity,
      selectedDistrict: selectedDistrict,
      getNameOfItem: (teams) => teams.name,
      getLocationOfItem: (teams) => teams.location,
    );
  }

  Future<void> updateTeamsForMatchDelete(String matchId) async {
    final teamCollection = FirebaseFirestore.instance.collection('teams');
    final teamDocs = await teamCollection.get();

    for (var teamDoc in teamDocs.docs) {
      final teamData = teamDoc.data();

      void updateField(String fieldName) {
        if (teamData[fieldName] is Map) {
          final fieldMap = Map<String, bool>.from(teamData[fieldName] ?? {});
          fieldMap.remove(matchId);
          teamData[fieldName] = fieldMap;
        } else if (teamData[fieldName] is List) {
          final fieldList =
              List<Map<String, dynamic>>.from(teamData[fieldName] ?? []);
          fieldList.removeWhere((item) => item['matchId'] == matchId);
          teamData[fieldName] = fieldList;
        }
      }

      // Fields to update
      final fields = [
        'incomingMatch',
        'joinMatchRequest',
        'matchInviteRequest',
        'matchJoinRequest',
        'matchSentRequest',
      ];

      // Update all relevant fields
      for (var field in fields) {
        updateField(field);
      }

      // Update the team document
      await teamDoc.reference.update(teamData);
    }
  }

  Future<List<TeamInformation?>> joinedTeam() async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentReference currentUser =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final DocumentSnapshot userSnapshot = await currentUser.get();

      if (userSnapshot.exists) {
        List<dynamic> joinedTeamsDynamic = userSnapshot['joinedTeams'] ?? [];
        List<String> joinedTeams =
            joinedTeamsDynamic.map((team) => team.toString()).toList();
        List<TeamInformation> fetchedTeams = [];
        for (var team in joinedTeams) {
          final DocumentReference teamRef =
              FirebaseFirestore.instance.collection('teams').doc(team);
          final DocumentSnapshot teamSnapshot = await teamRef.get();

          if (teamSnapshot.exists) {
            final location = LocationInfo(
              address: teamSnapshot['address'],
              district: teamSnapshot['district'],
              city: teamSnapshot['city'],
            );
            final teamInformation = TeamInformation(
              name: teamSnapshot['name'],
              location: location,
              avatarImageUrl: teamSnapshot['avatarImage'],
              incoming: Map<String, bool>.from(teamSnapshot['incomingMatch']),
              members: List<String>.from(teamSnapshot['members']),
              captain: teamSnapshot['captain'],
              teamId: teamSnapshot.id,
              foundedDate: (teamSnapshot['foundedDate'] as Timestamp).toDate(),
              images: List<String>.from(teamSnapshot['images']),
            );
            fetchedTeams.add(teamInformation);
          }
        }
        return fetchedTeams;
      } else {
        // return a list with on TeamInformation object
        return [];
      }
    } catch (e) {
      throw Exception('Error getting joined team information: $e');
    }
  }

  bool isNotJoined(String team, List<String> joinedTeams) {
    return !joinedTeams.any((element) => element == team);
  }

  Future<List<TeamInformation>> getNearbyTeam() async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentReference currentUser =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      final DocumentSnapshot userSnapshot = await currentUser.get();
      if (userSnapshot.exists) {
        List<TeamInformation> fetchedTeam = [];
        List<dynamic> joinedTeamsDynamic = userSnapshot['joinedTeams'] ?? [];
        List<String> joinedTeams =
            joinedTeamsDynamic.map((team) => team.toString()).toList();
        // Get the collection reference
        List<TeamInformation> teamData = await getTeamData();
        print('${teamData.length}');
        teamData.forEach(
          (team) {
            if (isNotJoined(team.teamId, joinedTeams)) {
              fetchedTeam.add(team);
            }
          },
        );
        return fetchedTeam;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error getting all team information: $e');
    }
  }

  int getTeamMemberCount(TeamInformation teamInformation) {
    return teamInformation.members.length;
  }

  Future<String> getTeamCaptain(String teamId) async {
    TeamInformation? teamInformation = await getTeamInformation(teamId);
    PlayerData? playerData =
        await userService.getPlayerData(teamInformation!.captain);

    return playerData!.name;
  }

  Future<void> teamProcessing({
    required String action,
    required Map<String, TextEditingController> controllers,
    required LocationInfo? location,
    required String selectedCity,
    required String selectedDistrict,
    required File avatar,
    required List<File> images,
    TeamInformation? teamInformation,
  }) async {
    print('team proc called');
    if (action == 'create') {
      print('team create being called');
      await createTeam(
        teamName: controllers['teamName']!.text,
        location: location!,
        avatar: avatar,
        images: images,
      );
    }
    if (action == 'edit') {
      await editTeam(
        team: teamInformation!,
        teamName: controllers['teamName']!.text,
        location: location!,
        avatar: avatar,
        images: images,
      );
    }
  }

  Future<void> createTeam({
    required String teamName,
    required LocationInfo location,
    required File avatar,
    required List<File> images,
  }) async {
    final captain = FirebaseAuth.instance.currentUser!.uid;
    final teamRef = await FirebaseFirestore.instance.collection('teams').add({
      'name': teamName,
      'city': location.city,
      'district': location.district,
      'address': '',
      'incomingMatch': {},
      'members': [captain],
      'captain': captain,
      'matchSentRequest': [],
      'matchInviteRequest': [],
      'foundedDate': Timestamp.now(),
    });

    final teamId = teamRef.id;
    await uploadAvatar(avatar, teamId);
    await uploadImages(images, teamId);

    final userRef = FirebaseFirestore.instance.collection('users').doc(captain);
    userRef.update({
      'joinedTeams': FieldValue.arrayUnion([teamId]),
    });
  }

  Future<void> editTeam({
    required TeamInformation team,
    required String teamName,
    required LocationInfo location,
    required File avatar,
    required List<File> images,
  }) async {
    final teamRef =
        FirebaseFirestore.instance.collection('teams').doc(team.teamId);

    await teamRef.update({
      'name': teamName,
      'city': location.city,
      'district': location.district,
    });

    await uploadAvatar(avatar, team.teamId);
    await uploadImages(images, team.teamId);
    for (int i = images.length; i < team.images.length; ++i) {
      await FirebaseStorage.instance
          .ref()
          .child('teams')
          .child(team.teamId)
          .child('images')
          .child('image_$i.jpg')
          .delete();
    }
  }

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

  Future<File> downloadAvatarFile(String teamId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('teams')
        .child(teamId)
        .child('avatar')
        .child('avatar.jpg');

    try {
      final tempDir = await getTemporaryDirectory();
      final avatar = File('${tempDir.path}/avatar.jpg');

      await ref.writeToFile(avatar);

      return avatar;
    } catch (e) {
      throw Exception('Failed to download avatar file: $e');
    }
  }

  Future<List<File>> downloadImageFiles(
      String stadiumId, int imageslength) async {
    List<File> files = [];

    for (int i = 0; i < imageslength; i++) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('teams')
          .child(stadiumId)
          .child('images')
          .child('image_$i.jpg');

      try {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/image_$i.jpg');

        await ref.writeToFile(file);

        files.add(file);
      } catch (e) {
        throw Exception('Failed to download image files: $e');
      }
    }
    return files;
  }

  Future<int> getUserAge(String dob) async {
    final dobSplit = dob.split('/');
    final dobYear = int.parse(dobSplit[2]);
    final now = DateTime.now();
    final nowYear = now.year;
    return nowYear - dobYear;
  }
}
