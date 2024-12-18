import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTeamsListView extends StatefulWidget {
  const MyTeamsListView({super.key});

  @override
  State<MyTeamsListView> createState() => _MyTeamsListViewState();
}

class _MyTeamsListViewState extends State<MyTeamsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TeamEntity> teamsInformation = [];
  bool isLoading = true;
  late Future<void> initializationFuture;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {

    List<TeamEntity> fetchedInformation = await UseCaseProvider.getUseCase<GetTeamByPlayer>().call(
      GetTeamByPlayerParams(playerId: FirebaseAuth.instance.currentUser!.uid),
    ).then((value) => value.data ?? []); 

    setState(() {
      teamsInformation = fetchedInformation;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: SizedBox(
        height: teamsInformation.isEmpty? 100 : 405,
        width: double.infinity,
        child: FutureBuilder<void>(
          future: initializationFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("No data exists, please create a team"));
            } else if (teamsInformation.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: Text("No teams found, lets create one!")
                )
              );
            }
            
            else {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 0, left: 8),
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

  final TeamEntity? teamInformation;
  final AnimationController? animationController;
  final Animation<double>? animation;

  int get getMemberCount {
    return teamInformation!.players.length;
  }
  bool get isCaptain {
    return teamInformation!.captain.id == FirebaseAuth.instance.currentUser!.uid;
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
                        return TeamDetails(teamId: teamInformation!.id);
                      },
                    ),
                  ),
                },
                child: Container(
                  width: 280,
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
                          width: 290,
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
                              teamInformation!.avatar.path,
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
                                      teamInformation!.captain.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: SportifindTheme.normalTextBlack),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('$getMemberCount members',
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
                              InkWell(
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
                                  height: 41,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: SportifindTheme.bluePurple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'View',
                                        style: SportifindTheme.normalTextWhite
                                            .copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
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
