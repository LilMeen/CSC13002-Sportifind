import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/widgets/my_teams_listview.dart';
import 'package:sportifind/models/player_data.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key, required this.playerId});
  final String playerId;

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with TickerProviderStateMixin {
  PlayerData? playerInformation;
  bool isLoading = true;
  late AnimationController animationController;
  List<TeamInformation> teamsInformation = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    fetchPlayerDetails();
    joinedTeam();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void fetchPlayerDetails() async {
    PlayerData? fetchedPlayer = await getPlayerInformation();
    if (fetchedPlayer == null) {
      print('Player information not found');
      return;
    }
    setState(() {
      playerInformation = fetchedPlayer;
      isLoading = false;
    });
  }

  Future<void> joinedTeam() async {
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
              teamId: teamSnapshot.id,
              name: teamSnapshot['name'],
              location: location,
              avatarImageUrl: teamSnapshot['avatarImage'],
              incoming: Map<String, bool>.from(teamSnapshot['incoming']),
              members: List<String>.from(teamSnapshot['members']),
              captain: teamSnapshot['captain'],
              foundedDate: (teamSnapshot['foundedDate'] as Timestamp).toDate(),
            );
            fetchedTeams.add(teamInformation);
          }
        }

        setState(() {
          teamsInformation = fetchedTeams;
          isLoading = false; // Update loading state
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'User document does not exist. Please sign out and sign in again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching your teams list'),
        ),
      );
    }
  }

  Future<PlayerData?> getPlayerInformation() async {
    try {
      DocumentReference<Map<String, dynamic>> playerRef =
          FirebaseFirestore.instance.collection('users').doc(widget.playerId);
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await playerRef.get();

      if (playerSnapshot.exists) {
        PlayerData playerInformation =
            PlayerData.fromSnapshot(playerSnapshot);
        return playerInformation;
      } else {
        throw Exception('Player not found');
      }
    } catch (e) {
      print('Error fetching player details: $e');
      return null;
    }
  }

  @override
  Widget build(context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (playerInformation == null) {
      return const Center(
        child: Text('Player not found'),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              SportifindTheme.whiteSmoke,
            ],
          ),
        ),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              const SportifindAppBar(title: 'Player Details'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.network(
                                    playerInformation!.avatarImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Player: '),
                                        Text(
                                          playerInformation!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            letterSpacing: 0.27,
                                            color: SportifindTheme.darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text('Rating: '),
                                        Text(
                                          'Fix this later',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 18,
                                            letterSpacing: 0.27,
                                            color: SportifindTheme.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), // avatar and team basic info
                      ),
                      const Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('DETAILS: '),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Address: '),
                                  Text(
                                      '${playerInformation!.location.address} ${playerInformation!.location.district} ${playerInformation!.location.city}'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                      'Level: '), // add team evaluation here
                                  const Text('Medium Level'),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Joined Team'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Builder(
                    builder: (BuildContext context) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: playerInformation!.teams.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = playerInformation!.teams.length > 25
                              ? 25
                              : playerInformation!.teams.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController.forward();

                          return TeamBox(
                            teamInformation: teamsInformation[index],
                            animation: animation,
                            animationController: animationController,
                          ); //////// 1. Add callback function
                          // );
                          // } else if (index == Category.categoryList.length) {
                          //   return AddTeam(
                          //     animation: animation,
                          //     animationController: animationController,
                          //     addTeam: callBack,
                          //   );
                          // }
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 20,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
