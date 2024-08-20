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
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/screens/player/team/widgets/team_list.dart';

class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key, required this.user, required this.role});
  final PlayerData user;
  final String role;

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with TickerProviderStateMixin {
  UserService userServices = UserService();
  TeamService teamService = TeamService();
  List<TeamInformation?> userTeams = [];
  bool isLoading = true;
  late AnimationController animationController;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _initializationFuture = _initialize();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    userTeams = await teamService.getUserTeams(widget.user.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Player information',
                style: SportifindTheme.sportifindAppBarForFeature.copyWith(
                  fontSize: 28,
                  color: SportifindTheme.bluePurple,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    child: SizedBox(
                      height: 100,
                      width: 300,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(widget.user.avatarImage),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.name,
                                    style: SportifindTheme
                                        .sportifindAppBarForFeature
                                        .copyWith(
                                      fontSize: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Overall Stat ',
                                    style: SportifindTheme.normalTextWhite
                                        .copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '80', //  waiting for stat for player
                                    style: SportifindTheme.normalTextBlack
                                        .copyWith(
                                      fontSize: 16,
                                      color: SportifindTheme.bluePurple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Age     ',
                                    style: SportifindTheme.normalTextWhite
                                        .copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${teamService.getUserAge(widget.user.dob)}',
                                    style: SportifindTheme.normalTextWhite
                                        .copyWith(
                                      fontSize: 16,
                                      color: SportifindTheme.bluePurple,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.user.location.address}, ${widget.user.location.district}, ${widget.user.location.city}',
                              style: SportifindTheme.normalTextWhite.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '180', // height here
                              style: SportifindTheme.normalTextWhite.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Joined Teams',
                      style: SportifindTheme.normalTextBlack.copyWith(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TeamList(teams: userTeams),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: widget.role == 'other'
                            ? Text(
                                'Add',
                                style:
                                    SportifindTheme.featureTitleBlack.copyWith(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(height: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
