import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_nearby_team.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';

class NearbyTeamListView extends StatefulWidget {
  const NearbyTeamListView({super.key, this.myTeam});
  final TeamEntity? myTeam;

  @override
  State<NearbyTeamListView> createState() => _NearbyTeamListViewState();
}

class _NearbyTeamListViewState extends State<NearbyTeamListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamEntity> teams = [];
  late Future<void> initializationFuture;
  bool isLoading = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    final PlayerEntity playerData = await UseCaseProvider.getUseCase<GetPlayer>().call(
      GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid),
    ).then((value) => value.data!);
    
    List<TeamEntity> nearbyTeams = await UseCaseProvider.getUseCase<GetNearbyTeam>().call(
      GetNearbyTeamParams(player: playerData),
    ).then((value) => value.data!);

    setState(() {
      teams = nearbyTeams;
      isLoading = false;
    });
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
            return SizedBox(
              height: teams.length * 200.0,
              child: Column(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 7,
                      childAspectRatio: 2.22,
                    ),
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
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
                ],
              ),
            );
          }
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

  final TeamEntity? teamInformation;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return teamInformation!.players.length;
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
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TeamDetails(teamId: teamInformation!.id);
                      },
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                          height: 135,
                          width: 122,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
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
                                10), // Specify the border radius
                            child: Image.network(
                              teamInformation!.avatar.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 2, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teamInformation!.name,
                                    style: SportifindTheme.featureTitlePurple
                                        .copyWith(
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$getMemberCount members',
                                    overflow: TextOverflow.ellipsis,
                                    style: SportifindTheme.normalTextBlack
                                        .copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${teamInformation!.location.district}, ${teamInformation!.location.city} City',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: SportifindTheme.normalTextBlack
                                        .copyWith(fontSize: 15),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return TeamDetails(
                                            teamId: teamInformation!.id);
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: SportifindTheme.bluePurple,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'View',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
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
