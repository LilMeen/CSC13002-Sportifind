// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/usecases/delete_match.dart';
import 'package:sportifind/features/match/domain/usecases/delete_match_annouce.dart';
import 'package:sportifind/features/match/presentation/screens/create_match/select_team_screen.dart';
import 'package:sportifind/features/match/presentation/screens/match_info/invite_team_screen.dart';
import 'package:sportifind/features/match/presentation/screens/match_main_screen.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';
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

  IconData? dummyIcon;
  StadiumEntity? matchStadium;
  Map<String, String> teamNames = {};
  List<TeamEntity> team = [];
  PlayerEntity? userData;
  bool isCaptain = false;
  int status = 0;

  get userTeamData => null;

  // bool checkCaptain() {
  //   var user = FirebaseAuth.instance.currentUser!.uid;
  //   return user == widget.matchInfo.team1.captain.id;
  // }

  Future<void> checkCaptain() async {
    userData = await UseCaseProvider.getUseCase<GetPlayer>()
        .call(
          GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid),
        )
        .then((value) => value.data);

    for (var i = 0; i < userData!.teamsId.length; ++i) {
      var userTeamData = await UseCaseProvider.getUseCase<GetTeam>()
          .call(
            GetTeamParams(id: userData!.teamsId[i]),
          )
          .then((value) => value.data);
      if (userTeamData!.captain.id == userData!.id) {
        setState(() {
          isCaptain = true;
        });
        break;
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to delete this match? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await UseCaseProvider.getUseCase<DeleteMatch>()
                    .call(DeleteMatchParams(
                  id: widget.matchInfo.id,
                ));
                await UseCaseProvider.getUseCase<DeleteMatchAnnouce>().call(
                  DeleteMatchAnnouceParams(
                      senderId: widget.matchInfo.team1.id,
                      matchId: widget.matchInfo.id),
                );
                widget.matchInfo.team2 != null
                    ? await UseCaseProvider.getUseCase<DeleteMatchAnnouce>()
                        .call(
                        DeleteMatchAnnouceParams(
                            senderId: widget.matchInfo.team2!.id,
                            matchId: widget.matchInfo.id),
                      )
                    : null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MatchMainScreen(),
                  ),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializationFuture = _initialize();
    checkCaptain();
  }

  Future<void> _initialize() async {
    if (widget.matchStatus != 3) {
      userData = await UseCaseProvider.getUseCase<GetPlayer>()
          .call(GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid))
          .then((value) => value.data);
    }
    matchStadium = widget.matchInfo.stadium;

    team1ImageProvider = NetworkImage(widget.matchInfo.team1.avatar.path);
    widget.matchInfo.team2 != null
        ? team2ImageProvider = NetworkImage(widget.matchInfo.team2!.avatar.path)
        : dummyIcon = Icons.question_mark;
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
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
                                          style:
                                              SportifindTheme.normalTextWhite,
                                        ),
                                      ],
                                    ),
                                  ),
                                  isCaptain == true &&
                                          widget.matchInfo.team1.captain.id ==
                                              user.uid
                                      ? PopupMenuButton(
                                          constraints: const BoxConstraints(
                                            maxWidth: 40,
                                          ),
                                          color: Colors.white,
                                          itemBuilder: (context) {
                                            return [
                                              const PopupMenuItem(
                                                value: 'delete',
                                                height: 30,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 8),
                                                child: Icon(Icons.delete,
                                                    size: 25),
                                              ),
                                            ];
                                          },
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              _showDeleteDialog();
                                            }
                                          },
                                          child: const Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
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
                                                  teamId:
                                                      widget.matchInfo.team1.id,
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
                                        child: widget.matchInfo.team2 != null
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    team2ImageProvider,
                                              )
                                            : Icon(
                                                dummyIcon,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        widget.matchInfo.team2?.name ??
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
                                ? widget.matchInfo.team1.name
                                : widget.matchInfo.team2?.name ?? "Unknow",
                            style: SportifindTheme.matchTeamInfo,
                          ),
                          widget.matchInfo.team2?.name == null && status == 1
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.5,
                                    left: 15,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TeamDetails(
                                            teamId: widget.matchInfo.team1.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "view details",
                                          style:
                                              SportifindTheme.viewTeamDetails,
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
                    SizedBox(
                        height: 280,
                        child: MemberCards(
                            status: status, matchInfo: widget.matchInfo)),
                    if (widget.matchStatus == 0 &&
                        isCaptain == true &&
                        status == 1 &&
                        widget.matchInfo.team2 == null)
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
                            child: Text(
                              "Invite a team",
                              style: SportifindTheme.normalTextWhiteLexend,
                            ),
                          ),
                        ),
                      )
                    else if (widget.matchStatus == 1 &&
                        isCaptain == true &&
                        status == 1 &&
                        widget.matchInfo.team2 == null)
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
                                  builder: (context) => SelectTeamScreen(
                                    forMatchCreate: false,
                                    forJoinRequest: true,
                                    hostId: widget.matchInfo.team1.id,
                                    matchId: widget.matchInfo.id,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Join this match",
                              style: SportifindTheme.normalTextWhiteLexend,
                            ),
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
