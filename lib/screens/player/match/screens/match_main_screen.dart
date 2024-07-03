import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/tab_icon.dart';
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
    return const MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: SportifindTheme.nearlyBlack,
          body: Center(
            child: Expanded(
              child: Column(
                children: [
                  MatchCards(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
