import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/models/player_data.dart';

class NearbyTeamListView extends StatefulWidget {
  const NearbyTeamListView({super.key, this.myTeam});
  final TeamInformation? myTeam;

  @override
  State<NearbyTeamListView> createState() => _NearbyTeamListViewState();
}

class _NearbyTeamListViewState extends State<NearbyTeamListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamInformation> teams = [];
  TeamService teamService = TeamService();
  UserService userService = UserService();
  late Future<void> initializationFuture;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    final PlayerData playerData = await userService.getUserPlayerData();
    List<TeamInformation> currentTeams = await teamService.getNearbyTeam();
    teams = teamService.sortTeamByLocation(currentTeams, playerData.location);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: FutureBuilder<void>(
        future: initializationFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 0.8,
              ),
              children: List<Widget>.generate(
                teams.length,
                (int index) {
                  final int count = teams.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return TeamBox2(
                    teamInformation: teams[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class NearbyTeamBox extends StatelessWidget {
  const NearbyTeamBox({
    super.key,
    this.team,
    this.animationController,
    this.animation,
  });

  final TeamInformation? team;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return team!.members.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, 
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation!.value), 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TeamDetails(teamId: team!.teamId);
                      },
                    ),
                  );
                },
                child: SizedBox(
                  height: 280,
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
                                                team!.name,
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
                                                    '$getMemberCount members',
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
                                                          '5',
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
                                  team!.avatarImageUrl,
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
      ),
    );
  }
}

class TeamBox2 extends StatelessWidget {
  const TeamBox2({
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
    return SizedBox(
      height: 170, 
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation!.value), 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TeamDetails(teamId: teamInformation!.teamId);
                      },
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 120,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          margin: const EdgeInsets.all(10),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
          );
        },
      ),
    );
  }
}
