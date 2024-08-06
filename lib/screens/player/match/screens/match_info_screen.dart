import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/Invite_team_screen.dart';
import 'package:sportifind/screens/player/match/screens/select_team_screen.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/user_service.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({super.key, required this.matchInfo});

  final MatchCard matchInfo;

  @override
  State<StatefulWidget> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  late Future<void> initializationFuture;
  late ImageProvider team1ImageProvider;
  late ImageProvider team2ImageProvider;
  MatchService matchService = MatchService();
  UserService userService = UserService();
  late Map<String, String> teamNames;
  PlayerData? userData;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    teamNames = await matchService.generateTeamMap();
    userData = await userService.getUserPlayerData();

    team1ImageProvider = NetworkImage(widget.matchInfo.avatarTeam1);
    team2ImageProvider = NetworkImage(
      widget.matchInfo.avatarTeam2.isEmpty
          ? "https://imgur.com/S1rPE1S.png"
          : widget.matchInfo.avatarTeam2,
    );

    await precacheImage(team1ImageProvider, context);
    await precacheImage(team2ImageProvider, context);
  }

  void _openInviteTeam() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => InviteTeamScreen(
        matchInfo: widget.matchInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match information"),
      ),
      body: FutureBuilder<void>(
        future: initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TeamDetails(
                                            teamId: widget.matchInfo.team1,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.greenAccent[400],
                                      radius: 50,
                                      backgroundImage: team1ImageProvider,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  teamNames[widget.matchInfo.team1] ??
                                      "Unknown",
                                  style: SportifindTheme.title,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 26.0),
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.matchInfo.team2 == "" &&
                                          userData!.teams.any((element) =>
                                              element ==
                                              widget.matchInfo.team1)) {
                                        _openInviteTeam();
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SelectTeamScreen(
                                              forMatchCreate: false,
                                              forJoinRequest: true,
                                              hostId: widget.matchInfo.team1,
                                              matchId: widget.matchInfo.id,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 50,
                                      backgroundImage: team2ImageProvider,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  teamNames[widget.matchInfo.team2] ??
                                      "Unknown",
                                  style: SportifindTheme.title,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: []),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
