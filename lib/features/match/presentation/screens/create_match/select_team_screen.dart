import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/usecases/send_request_to_join_match.dart';
import 'package:sportifind/features/match/presentation/screens/match_main_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/player/player_stadium_screen.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({
    super.key,
    this.forMatchCreate = true,
    this.forJoinRequest = false,
    this.hostId,
    this.matchId,
  });

  final bool forMatchCreate;
  final bool forJoinRequest;
  final String? hostId;
  final String? matchId;

  @override
  State<StatefulWidget> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  List<TeamEntity> userTeams = [];

  Future<void> fetchingData() async {
    if (widget.forMatchCreate == true || widget.forJoinRequest == true) {
      userTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>()
          .call(
            GetTeamByPlayerParams(
                playerId: FirebaseAuth.instance.currentUser!.uid),
          )
          .then((value) => value.data ?? []);
    }
    for (var i = 0; i < userTeams.length; ++i) {
      if (userTeams[i].captain.id != FirebaseAuth.instance.currentUser!.uid) {
        userTeams.remove(userTeams[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<void>(
                future: fetchingData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading teams'));
                  } else if (userTeams.isNotEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: userTeams.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (ctx, index) {
                              return makeTeamItem(userTeams[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No teams available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeTeamItem(TeamEntity team) {
    return GestureDetector(
      onTap: () {
        if (widget.forMatchCreate == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerStadiumScreen(
                forMatchCreate: true,
                selectedTeam: team,
              ),
            ),
          );
        } else if (widget.forJoinRequest == true) {
          UseCaseProvider.getUseCase<SendRequestToJoinMatch>().call(
            SendRequestToJoinMatchParams(
              teamSendId: team.id,
              teamReceiveId: widget.hostId!,
              matchId: widget.matchId!,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MatchMainScreen(),
            ),
          );
        }
      },
      child: Container(
        height: 100,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: SportifindTheme.bluePurple, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                team.name,
                style: TextStyle(
                  color: SportifindTheme.bluePurple,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: SportifindTheme.bluePurple,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${team.location.district}, ${team.location.city}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Maximum number of lines for the text
                      overflow: TextOverflow
                          .clip, // Add ellipsis (...) if text overflows
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.group_outlined,
                    color: SportifindTheme.bluePurple,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${team.players.length} members",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: SportifindTheme.bluePurple,
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(
                    onPressed: () {
                      if (widget.forMatchCreate == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerStadiumScreen(
                              forMatchCreate: true,
                              selectedTeam: team,
                            ),
                          ),
                        );
                      } else if (widget.forJoinRequest == true) {
                        UseCaseProvider.getUseCase<SendRequestToJoinMatch>()
                            .call(
                          SendRequestToJoinMatchParams(
                            teamSendId: team.id,
                            teamReceiveId: widget.hostId!,
                            matchId: widget.matchId!,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MatchMainScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Pick this team",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
