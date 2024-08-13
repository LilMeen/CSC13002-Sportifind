import 'package:flutter/material.dart';
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
import 'package:sportifind/screens/player/team/screens/player_details.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/models/player_data.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({super.key, required this.teamId});
  final String teamId;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails>
    with SingleTickerProviderStateMixin {
  TeamInformation? teamInformation;
  bool isLoading = true;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    fetchTeamDetails(widget.teamId);
  }

  Future<void> fetchTeamDetails(String teamId) async {
    TeamService teamService = TeamService();
    teamInformation = await teamService.getTeamInformation(teamId);

    teamInformation ?? TeamInformation.empty();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // void fetchTeamDetails() async {
  //   TeamInformation? fetchedTeam = await getTeamInformation();
  //   if (fetchedTeam == null) {
  //     print('No team information found!');
  //     return;
  //   }
  //   setState(
  //     () {
  //       teamInformation = fetchedTeam;
  //       isLoading = false;
  //     },
  //   );
  // }

  // Future<TeamInformation?> getTeamInformation() async {
  //   try {
  //     // Reference to the specific team document
  //     DocumentReference<Map<String, dynamic>> teamRef =
  //         FirebaseFirestore.instance.collection('teams').doc(widget.teamId);

  //     // Get the document
  //     DocumentSnapshot<Map<String, dynamic>> teamSnapshot = await teamRef.get();

  //     // Check if the document exists
  //     if (teamSnapshot.exists) {
  //       // Use the fromSnapshot constructor to create a TeamInformation object
  //       TeamInformation teamInformation =
  //           TeamInformation.fromSnapshot(teamSnapshot);
  //       return teamInformation;
  //     } else {
  //       print('No such team document exists!');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting team information: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (teamInformation == null) {
      return const Center(
        child: Text('No team information found!'),
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
              const SportifindAppBar(title: 'Team Details'),
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
                                    teamInformation!.avatarImageUrl,
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
                                        const Text('Team Name: '),
                                        Text(
                                          teamInformation!.name,
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
                                        Text('Level: '),
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
                                      '${teamInformation!.location.address} ${teamInformation!.location.district} ${teamInformation!.location.city}'),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Players: '),
                                  Text('${teamInformation!.members.length}'),
                                ],
                              ),
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
                            Text('Members'),
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
                        itemCount: teamInformation!.members.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = teamInformation!.members.length > 25
                              ? 10
                              : teamInformation!.members.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController.forward();

                          return PlayerBox(
                              player: teamInformation!.members[index],
                              animation: animation,
                              animationController: animationController,
                              callback: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayerDetails(
                                            playerId: teamInformation!
                                                .members[index])));
                              }); //////// 1. Add callback function
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

Future<bool> getData() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 50));
  return true;
}

class PlayerBox extends StatefulWidget {
  const PlayerBox(
      {super.key,
      this.player,
      this.animationController,
      this.animation,
      this.callback});

  final VoidCallback? callback;
  final String? player;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  State<PlayerBox> createState() => _PlayerBoxState();
}

class _PlayerBoxState extends State<PlayerBox> {
  PlayerData? playerInformation;
  bool isLoading = true;

  Future<PlayerData?> getPlayerInformation(String playerId) async {
    try {
      // Reference to the specific team document
      DocumentReference<Map<String, dynamic>> playerRef =
          FirebaseFirestore.instance.collection('users').doc(playerId);

      // Get the document
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await playerRef.get();

      // Check if the document exists
      if (playerSnapshot.exists) {
        // Use the fromSnapshot constructor to create a TeamInformation object
        PlayerData playerInformation =
            PlayerData.fromSnapshot(playerSnapshot);
        return playerInformation;
      } else {
        print('No such player document exists!');
        return null;
      }
    } catch (e) {
      print('Error getting player information: $e');
      return null;
    }
  }

  void fetchPlayerDetails() async {
    PlayerData? fetchedPlayer =
        await getPlayerInformation(widget.player!);
    setState(() {
      playerInformation = fetchedPlayer;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPlayerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: widget.callback,
              child: SizedBox(
                height: 100,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 16, right: 16),
                                            child: Text(
                                              playerInformation!.name,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: SportifindTheme.darkGrey,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Age: ${playerInformation!.dob}}',
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color: SportifindTheme.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Text(
                                                        '5', // create a function to evaluate player base on their skill which is defined
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color: SportifindTheme
                                                              .grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: SportifindTheme
                                                            .bluePurple,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 1.28,
                              child: Image.network(
                                playerInformation!.avatarImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TourismCard extends StatelessWidget {
  const TourismCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 3)
          ],),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              height: 120,
              width: 220,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('Place Name',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      Spacer(),
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      SizedBox(width: 5),
                      Text(
                        '( 12 )',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    maxLines: 2,
                    textHeightBehavior: TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: const TextSpan(
                      text: r'$160.05',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text: '  /night ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
