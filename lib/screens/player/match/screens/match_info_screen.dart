import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/match/screens/Invite_team_screen.dart';
import 'package:sportifind/screens/player/match/screens/select_team_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  late Future<void> initializationFuture;
  late ImageProvider team1ImageProvider;
  late ImageProvider team2ImageProvider;
  MatchService matchService = MatchService();
  UserService userService = UserService();
  TeamService teamService = TeamService();
  StadiumService stadiumService = StadiumService();
  StadiumData? matchStadium;
  Map<String, String> teamNames = {};
  List<TeamInformation> team = [];
  PlayerData? userData;
  int status = 0;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    teamNames = await teamService.generateTeamMap();
    final teamInfo = await teamService.getTeamData();
    for (var i = 0; i < teamInfo.length; ++i) {
      if (teamInfo[i].captain == user.uid) {
        continue;
      }
      team.add(teamInfo[i]);
    }
    if (widget.matchStatus != 3) {
      userData = await userService.getUserPlayerData();
    }
    matchStadium =
        await stadiumService.getSpecificStadiumsData(widget.matchInfo.stadium);

    await precacheImage(team1ImageProvider, context);
    await precacheImage(team2ImageProvider, context);
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
                      height: 420,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_ios,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Back",
                                      style: SportifindTheme.normalTextWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
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
                                                        teamId: widget
                                                            .matchInfo.team1,
                                                        role: 'teamMember'),
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
                                        style: SportifindTheme.matchCardItem,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 26.0),
                                    child: Text("VS",
                                        style: SportifindTheme.matchVS),
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 50,
                                          backgroundImage: team2ImageProvider,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        teamNames[widget.matchInfo.team2] ??
                                            "Unknown",
                                        style: SportifindTheme.matchCardItem,
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
                                  const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${widget.matchInfo.start}, ${widget.matchInfo.date}",
                                    style: SportifindTheme.normalTextWhite,
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
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.hourglass_top_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.matchInfo.playTime,
                                    style: SportifindTheme.normalTextWhite,
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
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Icon(
                                      Icons.stadium_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "${matchStadium!.name} stadium, ${matchStadium!.location.address}, ${matchStadium!.location.district}, ${matchStadium!.location.city}",
                                      style: SportifindTheme.normalTextWhite,
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
                        width: 370,
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
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            status == 0
                                ? teamNames[widget.matchInfo.team1] ?? "Unknow"
                                : teamNames[widget.matchInfo.team2] ?? "Unknow",
                            style: SportifindTheme.matchTeamInfo,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.5,
                              left: 15,
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    "view details",
                                    style: SportifindTheme.viewTeamDetails,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 4.0),
                                    child: SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        'lib/assets/button_icon/arrow-right.svg',
                                        fit: BoxFit.fill,
                                        color: SportifindTheme.bluePurple,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    MemberCards(status: status, matchInfo: widget.matchInfo),
                    if (widget.matchStatus == 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: SportifindTheme.bluePurple),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InviteTeamScreen(
                                    matchInfo: widget.matchInfo,
                                    teams: team,
                                    userLocation: userData!.location,
                                  ),
                                ),
                              );
                            },
                            child: Text("Invite a team"),
                          ),
                        ),
                      )
                    else if (widget.matchStatus == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: SportifindTheme.bluePurple),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectTeamScreen(),
                                ),
                              );
                            },
                            child: Text("Join this match"),
                          ),
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
