import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/presentation/screens/create_match/select_team_screen.dart';
import 'package:sportifind/features/match/presentation/screens/match_info/invite_team_screen.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';
import 'package:sportifind/features/team/presentation/widgets/member/member_card.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({ 
    super.key,
    required this.matchInfo,
    required this.matchStatus,
  });

  final MatchEntity matchInfo;
  final int matchStatus;

  @override
  State<StatefulWidget> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<void> initializationFuture;
  late ImageProvider team1ImageProvider;
  late ImageProvider team2ImageProvider;

  StadiumEntity? matchStadium;
  Map<String, String> teamNames = {};
  List<TeamEntity> team = [];
  PlayerEntity? userData;
  int status = 0;

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
  }

  Future<void> _initialize() async {
    if (widget.matchStatus != 3) {
      userData = await UseCaseProvider
        .getUseCase<GetPlayer>()
        .call(
          GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid)
        ).
        then((value) => value.data);
    }
    matchStadium = widget.matchInfo.stadium;

    team1ImageProvider = NetworkImage(widget.matchInfo.team1.avatar.path);
    team2ImageProvider = NetworkImage(
      widget.matchInfo.team2 == null
          ? "https://imgur.com/S1rPE1S.png"
          : widget.matchInfo.team2!.avatar.path,
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
                      height: 420,
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
                                                    teamId: widget.matchInfo.team1.id,
                                                    role: 'teamMember',
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
                                        widget.matchInfo.team1.name,
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
                                        widget.matchInfo.team2?.name ?? "Unknown",
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
                                ? widget.matchInfo.team1.name
                                : widget.matchInfo.team2?.name ?? "Unknow",
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
                                    child: Icon(
                                      Icons.arrow_forward_outlined,
                                      color: SportifindTheme.bluePurple
                                          .withAlpha(212),
                                      size: 16,
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
                            child: const Text("Invite a team"),
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
                            child: const Text("Join this match"),
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
