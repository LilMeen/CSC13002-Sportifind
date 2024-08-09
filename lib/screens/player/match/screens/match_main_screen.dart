import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/tab_icon.dart';
import 'package:sportifind/screens/player/match/screens/select_team_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/match_list/match_cards.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MatchMainScreen extends StatefulWidget {
  const MatchMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MatchMainScreenState();
}

bool isCaptain = false;

class _MatchMainScreenState extends State<MatchMainScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final List<MatchCard> _yourMatch = [];
  final List<MatchCard> _nearByMatch = [];
  int status = 0;

  UserService userService = UserService();
  TeamService teamService = TeamService();
  PlayerData? userData;
  TeamInformation? userTeamData;

  String errorMessage = '';

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Colors.white,
  );

  Future<void> checkCaptain() async {
    userData = await userService.getUserPlayerData();
    for (var i = 0; i < userData!.teams.length; ++i) {
      userTeamData = await teamService.getTeamInformation(userData!.teams[i]);
      if (userTeamData!.captain == userData!.id) {
        setState(() {
          isCaptain = true;
        });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkCaptain();

    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void addMatchCard(MatchCard matchcard) {
    setState(() {
      _yourMatch.add(matchcard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(isCaptain);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70, right: 10),
          child: isCaptain == true
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectTeamScreen(addMatchCard: addMatchCard),
                      ),
                    );
                  },
                  backgroundColor: SportifindTheme.bluePurple,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: SportifindTheme.bluePurple, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ToggleSwitch(
                    minWidth: width - 30,
                    minHeight: 50.0,
                    initialLabelIndex: status,
                    cornerRadius: 8.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: SportifindTheme.whiteEdgar,
                    inactiveFgColor: SportifindTheme.bluePurple,
                    totalSwitches: 2,
                    radiusStyle: true,
                    labels: const ['Your match', 'Nearby match'],
                    fontSize: 18.0,
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
                MatchCards(
                  yourMatch: _yourMatch,
                  nearByMatch: _nearByMatch,
                  status: status,
                ),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
