import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/match_info_screen.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/team_service.dart';

class MatchListItem extends StatefulWidget {
  const MatchListItem({super.key, required this.matchCard});

  final MatchCard matchCard;

  @override
  State<StatefulWidget> createState() => _MatchListItemState();
}

class _MatchListItemState extends State<MatchListItem> {
  String? teamName;
  MatchService matchService = MatchService();
  TeamService teamService = TeamService();
  late Future<void> initializationFuture;
  late ImageProvider team1ImageProvider;
  late ImageProvider team2ImageProvider;
  late Map<String, String> teamNames;

  Future<String> convertTeamIdToName(String teamId) async {
    final teamMap = await teamService.generateTeamNameMap();
    final teamName = teamMap[teamId] ?? 'Unknown Team';
    return teamName;
  }

  Future<void> fetchTeamName() async {
    final name = await convertTeamIdToName(widget.matchCard.team2);
    setState(() {
      teamName = name;
    });
  }

  Future<void> _initialize() async {
    teamNames = await matchService.generateTeamMap();

    team1ImageProvider = NetworkImage(widget.matchCard.avatarTeam1);
    team2ImageProvider = NetworkImage(
      widget.matchCard.avatarTeam2.isEmpty
          ? "https://imgur.com/S1rPE1S.png"
          : widget.matchCard.avatarTeam2,
    );

    await precacheImage(team1ImageProvider, context);
    await precacheImage(team2ImageProvider, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTeamName();
    initializationFuture = _initialize();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = matchService.parseDate(widget.matchCard.date);
    Map<int, String> month = {
      1: "JAN",
      2: "FEB",
      3: "MAR",
      4: "APR",
      5: "MAY",
      6: "JUNE",
      7: "JULY",
      8: "AUG",
      9: "SEP",
      10: "OCT",
      11: "NOV",
      12: "DEC"
    };
    return FutureBuilder<void>(
      future: initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchInfoScreen(
                    matchInfo: widget.matchCard,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "${date.day}\n",
                          style: const TextStyle(
                            color: SportifindTheme.bluePurple,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: month[date.month]!,
                              style: const TextStyle(
                                  color: SportifindTheme.bluePurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('lib/assets/images/match.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  Text(
                                    teamNames[widget.matchCard.team1] ??
                                        "Unknown",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: SportifindTheme.white,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: team1ImageProvider,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: Text(
                                "VS",
                                style: TextStyle(
                                  color: SportifindTheme.white,
                                  fontSize: 48,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  teamNames[widget.matchCard.team2] ??
                                      "Unknown",
                                  style: const TextStyle(
                                      color: SportifindTheme.white,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: team2ImageProvider,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.matchCard.start,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            const Icon(
                              Icons.hourglass_top_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.matchCard.playTime,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            const Icon(
                              Icons.stadium,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.matchCard.stadium,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
