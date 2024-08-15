// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/widgets/app_bar.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/team/presentation/widgets/my_teams_list_view.dart';


class PlayerDetails extends StatefulWidget {
  const PlayerDetails({super.key, required this.player});
  final PlayerEntity player;

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with TickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController animationController;
  List<TeamEntity> teamsInformation = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    fetchedTeams();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> fetchedTeams() async {
    try {
      List<TeamEntity> playerTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>().call(
        GetTeamByPlayerParams(
          playerId: widget.player.id,
        ),
      ).then((value) => value.data ?? []);

      setState(() {
        teamsInformation = playerTeams;
        isLoading = false; // Update loading state
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching your teams list'),
        ),
      );
    }
  }

  @override
  Widget build(context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
                                    widget.player.avatar.path,
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
                                          widget.player.name,
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
                                    const Row(
                                      children: [
                                        Text('Rating: '),
                                        Text(
                                          'Fix this later',
                                          style: TextStyle(
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
                                      '${widget.player.location.address} ${widget.player.location.district} ${widget.player.location.city}'),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      'Level: '), // add team evaluation here
                                  Text('Medium Level'),
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
                        itemCount: widget.player.teamsId.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = widget.player.teamsId.length > 25
                              ? 25
                              : widget.player.teamsId.length;
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
