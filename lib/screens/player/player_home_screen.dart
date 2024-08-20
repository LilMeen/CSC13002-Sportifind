import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/notify/screeens/notification_screen.dart';
import 'package:sportifind/screens/player/team/screens/team_main_screen.dart';
import 'package:sportifind/widgets/bottom_navigation.dart';
import 'package:sportifind/models/tab_icon.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/profile/profile_screen.dart';
import 'package:sportifind/screens/message/screens/group_chat_list.dart';

class PlayerHomeScreen extends StatefulWidget {
  const PlayerHomeScreen({super.key});

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Colors.white,
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sportifind',
                style: SportifindTheme.sportifindAppBar,
              ),
              Stack(children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    size: 35,
                    color: SportifindTheme.bluePurple,
                  ),
                ),
                const Positioned(
                  // draw a red marble
                  top: 10.0,
                  right: 10.0,
                  child: Icon(Icons.brightness_1_rounded,
                      size: 16.0, color: Color.fromARGB(255, 255, 0, 0)),
                ),
                const Positioned(
                  // draw a red marble
                  top: 10.0,
                  right: 10.0,
                  child: Icon(Icons.brightness_1_outlined,
                      size: 16.0, color: Colors.white),
                )
              ]),
              Stack(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupChatList(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.chat_bubble_outline_outlined,
                      size: 30,
                      color: SportifindTheme.bluePurple,
                    ),
                  ),
                  const Positioned(
                    // draw a red marble
                    top: 6.0,
                    right: 6.0,
                    child: Icon(Icons.brightness_1_rounded,
                        size: 16.0, color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                  const Positioned(
                    // draw a red marble
                    top: 6.0,
                    right: 6.0,
                    child: Icon(Icons.brightness_1_outlined,
                        size: 16.0, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
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
