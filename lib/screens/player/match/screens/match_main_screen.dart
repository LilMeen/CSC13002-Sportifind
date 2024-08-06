import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/tab_icon.dart';
import 'package:sportifind/screens/player/match/screens/select_team_screen.dart';
import 'package:sportifind/widgets/match_list/match_cards.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MatchMainScreen extends StatefulWidget {
  const MatchMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MatchMainScreenState();
}

class _MatchMainScreenState extends State<MatchMainScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final List<MatchCard> _yourMatch = [];
  final List<MatchCard> _nearByMatch = [];
  int status = 0;

  String errorMessage = '';

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: SportifindTheme.background,
  );

  @override
  void initState() {
    super.initState();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: SportifindTheme.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70, right: 10),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectTeamScreen(addMatchCard: addMatchCard),
                ),
              );
            },
            backgroundColor: SportifindTheme.darkGrey,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: SportifindTheme.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ToggleSwitch(
                  minWidth: width - 30,
                  minHeight: 50.0,
                  initialLabelIndex: status,
                  cornerRadius: 8.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  radiusStyle: true,
                  labels: const ['Your match', 'Nearby match'],
                  fontSize: 15.0,
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
