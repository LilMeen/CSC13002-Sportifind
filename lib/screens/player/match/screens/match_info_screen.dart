import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/match/screens/Invite_team_screen.dart';
import 'package:sportifind/screens/player/match/screens/select_team_screen.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/member_list/member_card.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({
    super.key,
    required this.matchInfo,
    required this.matchStatus,
  });

  final MatchCard matchInfo;
  final int matchStatus;

  @override
  State<StatefulWidget> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  late Future<void> initializationFuture;
  late ImageProvider team1ImageProvider;
  late ImageProvider team2ImageProvider;
  MatchService matchService = MatchService();
  UserService userService = UserService();
  TeamService teamService = TeamService();
  StadiumService stadiumService = StadiumService();
  StadiumData? matchStadium;
  Map<String, String> teamNames = {};
  PlayerData? userData;
  int status = 0;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    teamNames = await teamService.generateTeamMap();
    userData = await userService.getUserPlayerData();
    print(widget.matchInfo.stadium);
    matchStadium =
        await stadiumService.getSpecificStadiumsData(widget.matchInfo.stadium);

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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: initializationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 370,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/assets/images/matchDetailBackground.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 12,
                                color: SportifindTheme.white,
                              ),
                              label: Text(
                                "Back",
                                style: SportifindTheme.white16,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TeamDetails(
                                                  teamId:
                                                      widget.matchInfo.team1,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.greenAccent[400],
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
                                        style: SportifindTheme.white16,
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 26.0),
                                    child: Text(
                                      "VS",
                                      style: TextStyle(
                                        color: Colors.white,
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
                                                    hostId:
                                                        widget.matchInfo.team1,
                                                    matchId:
                                                        widget.matchInfo.id,
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
                                        style: SportifindTheme.white16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_outlined,
                                    color: SportifindTheme.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${widget.matchInfo.start}, ${widget.matchInfo.date}",
                                    style: SportifindTheme.white16,
                                    maxLines:
                                        2, // Maximum number of lines for the text
                                    overflow: TextOverflow
                                        .clip, // Add ellipsis (...) if text overflows
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.hourglass_top_rounded,
                                    color: SportifindTheme.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.matchInfo.playTime,
                                    style: SportifindTheme.white16,
                                    maxLines:
                                        2, // Maximum number of lines for the text
                                    overflow: TextOverflow
                                        .clip, // Add ellipsis (...) if text overflows
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.stadium_rounded,
                                    color: SportifindTheme.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "${matchStadium!.name} stadium, ${matchStadium!.location.address}, ${matchStadium!.location.district}, ${matchStadium!.location.city}",
                                      style: SportifindTheme.white16,
                                      maxLines:
                                          2, // Maximum number of lines for the text
                                      overflow: TextOverflow
                                          .clip, // Add ellipsis (...) if text overflows
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        width: 330,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: SportifindTheme.bluePurple, width: 1.0),
                          borderRadius: BorderRadius.circular(8),
                          color: SportifindTheme.whiteEdgar,
                        ),
                        child: ToggleSwitch(
                          minWidth: width - 80,
                          minHeight: 50.0,
                          initialLabelIndex: status,
                          cornerRadius: 8.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: SportifindTheme.whiteEdgar,
                          inactiveFgColor: SportifindTheme.bluePurple,
                          totalSwitches: 2,
                          radiusStyle: true,
                          labels: const ['Home', 'Away'],
                          fontSize: 20.0,
                          activeBgColors: const [
                            [Color.fromARGB(255, 76, 59, 207)],
                            [Color.fromARGB(255, 76, 59, 207)],
                          ],
                          animate:
                              true, // with just animate set to true, default curve = Curves.easeIn
                          curve: Curves
                              .fastOutSlowIn, // animate must be set to true when using custom curve
                          onToggle: (index) {
                            setState(() {
                              status = index!;
                              print(status);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 64.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            status == 0
                                ? teamNames[widget.matchInfo.team1] ?? "Unknow"
                                : teamNames[widget.matchInfo.team2] ?? "Unknow",
                            style: const TextStyle(
                                color: SportifindTheme.lead,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 11.5),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_outlined,
                                color:
                                    SportifindTheme.bluePurple.withAlpha(212),
                                size: 12,
                              ),
                              iconAlignment: IconAlignment.end,
                              label: Text(
                                "view details",
                                style: SportifindTheme.bluePurple16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    MemberCards(status: status, matchInfo: widget.matchInfo),
                    if (widget.matchStatus == 0)
                      Container(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(""),
                        ),
                      )
                    else if (widget.matchStatus == 1)
                      Container(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(""),
                        ),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
