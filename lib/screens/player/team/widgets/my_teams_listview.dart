import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
import 'package:sportifind/util/team_service.dart';

class MyTeamsListView extends StatefulWidget {
  const MyTeamsListView({super.key});

  @override
  State<MyTeamsListView> createState() => _MyTeamsListViewState();
}

class _MyTeamsListViewState extends State<MyTeamsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamInformation?> teamsInformation = [];
  bool isLoading = true;
  TeamService teamService = TeamService();
  late Future<void> initializationFuture;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    teamsInformation = await teamService.joinedTeam();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 350,
        width: double.infinity,
        child: FutureBuilder<void>(
          future: initializationFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: teamsInformation.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = teamsInformation.length > 10
                      ? 10
                      : teamsInformation.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return TeamBox(
                    teamInformation: teamsInformation[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class TeamBox extends StatelessWidget {
  const TeamBox({
    super.key,
    this.teamInformation,
    this.animationController,
    this.animation,
  });

  final TeamInformation? teamInformation;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return teamInformation!.members.length;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TeamDetails(teamId: teamInformation!.teamId);
                      },
                    ),
                  ),
                },
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 3,
                        blurStyle: BlurStyle.solid,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 160,
                          width: 270,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 3,
                                blurStyle: BlurStyle.solid,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                16), // Specify the border radius
                            child: Image.network(
                              teamInformation!.avatarImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    teamInformation!.name,
                                    style: SportifindTheme.featureTitlePurple
                                        .copyWith(
                                      fontSize: 26,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      //teamInformation!.captain,
                                      'Pham Gia Bao',
                                      overflow: TextOverflow.ellipsis,
                                      style: SportifindTheme.normalTextBlack),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('${getMemberCount} members',
                                      overflow: TextOverflow.ellipsis,
                                      style: SportifindTheme.normalTextBlack),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      '${teamInformation!.location.district}, ${teamInformation!.location.city}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: SportifindTheme.normalTextBlack),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
