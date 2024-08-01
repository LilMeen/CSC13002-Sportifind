import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/team/screens/team_main_screen.dart';
import 'package:sportifind/widgets/bottom_navigation.dart';
import 'package:sportifind/models/tab_icon.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/profile/profile_screen.dart';

class PlayerHomeScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PlayerHomeScreen());
  const PlayerHomeScreen({super.key});

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SportifindTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerHomeScreen()),
            );
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>(
                (data) {
                  if (!mounted) {
                    return;
                  }
                  setState(
                    () {
                      tabBody = const MatchMainScreen();
                    },
                  );
                },
              );
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>(
                (data) {
                  if (!mounted) {
                    return;
                  }
                  setState(
                    () {
                      tabBody = const PlayerStadiumScreen();
                    },
                  );
                },
              );
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>(
                (data) {
                  if (!mounted) {
                    return;
                  }
                  setState(
                    () {
                      tabBody = const TeamMainScreen();
                    },
                  );
                },
              );
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>(
                (data) {
                  if (!mounted) {
                    return;
                  }
                  setState(
                    () {
                      tabBody = const ProfileScreen();
                    },
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
