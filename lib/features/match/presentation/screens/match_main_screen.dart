import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/presentation/screens/create_match_screen.dart';
import 'package:sportifind/features/match/presentation/widgets/match_cards.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/profile/domain/usecases/get_player.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team.dart';
import 'package:sportifind/home/widgets/tab_icon.dart';
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
  final List<MatchEntity> _yourMatch = [];
  final List<MatchEntity> _nearByMatch = [];
  int status = 0;


  PlayerEntity? userData;
  TeamEntity? userTeamData;

  String errorMessage = '';

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Colors.white,
  );

  Future<void> checkCaptain() async {
    userData = await UseCaseProvider.getUseCase<GetPlayer>().call(
      GetPlayerParams(id: FirebaseAuth.instance.currentUser!.uid),
    ).then((value) => value.data);

    for (var i = 0; i < userData!.teamsId.length; ++i) {
      userTeamData = await UseCaseProvider.getUseCase<GetTeam>().call(
        GetTeamParams(id: userData!.teamsId[i]),
      ).then((value) => value.data);
      if (userTeamData!.captain.id == userData!.id) {
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

  void addMatchCard(MatchEntity matchcard) {
    setState(() {
      _yourMatch.add(matchcard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                        builder: (context) => const CreateMatchScreen(),
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
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
