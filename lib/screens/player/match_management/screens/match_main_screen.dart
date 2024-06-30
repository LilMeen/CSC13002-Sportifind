import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/tab_icon.dart';
import 'package:sportifind/widgets/bottom_navigation.dart';
import 'package:sportifind/screens/home_screen.dart';
import 'package:sportifind/widgets/match_list/match_cards.dart';

class MatchMainScreen extends StatefulWidget {
  const MatchMainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MatchMainScreenState();
}

class _MatchMainScreenState extends State<MatchMainScreen>
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
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  // Dummy dispose
  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: SportifindTheme.nearlyBlack,
          body: Center(
            child: Column(
              children: [
                const MatchCards(),
                const Spacer(),
                BottomBarView(
                  tabIconsList: tabIconsList,
                  addClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SportifindHomeScreen()),
                    );
                  },
                  changeIndex: (int index) {
                    if (index == 0 || index == 2) {
                      animationController?.reverse().then<dynamic>((data) {
                        if (!mounted) {
                          return;
                        }
                        setState(() {});
                      });
                    } else if (index == 1 || index == 3) {
                      animationController?.reverse().then<dynamic>((data) {
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MatchMainScreen()),
                          );
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
