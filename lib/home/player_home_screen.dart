import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sportifind/home/widgets/app_fader_effect.dart';
import 'package:sportifind/home/widgets/bottom_navigation.dart';
import 'package:sportifind/features/chat/presentation/screens/chat_main_screen.dart';
import 'dart:async';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/match/presentation/screens/match_main_screen.dart';
import 'package:sportifind/features/notification/domain/entities/notification_entity.dart';
import 'package:sportifind/features/notification/domain/usecases/get_notification.dart';
import 'package:sportifind/features/notification/presentation/screens/notification_screen.dart';
import 'package:sportifind/features/profile/presentation/screens/profile_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/player/player_stadium_screen.dart';
import 'package:sportifind/features/team/presentation/screens/team_main_screen.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class PlayerHomeScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PlayerHomeScreen());
  const PlayerHomeScreen({super.key});

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
  late final ScrollController _scrollController;
  bool _atBottom = false;
  List<NotificationEntity> userNoti = [];
  bool isLoading = true;
  Timer? _timer;
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    TeamMainScreen(),
    PlayerStadiumScreen(),
    MatchMainScreen(),
  ];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    // Call the method to get notifications immediately
    getNoti();

    // Set up the timer to refresh notifications every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      getNoti();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getNoti() async {
    userNoti = await UseCaseProvider.getUseCase<GetNotification>()(NoParams())
        .then((value) => value.data ?? []);
    setState(() {
      isLoading = false;
    });
  }

  /// Scroll Listener
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _atBottom = true;
      });
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _atBottom = false;
      });
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _atBottom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: _selectedIndex == 0 ? null : _appBar(context),
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              /// Application Body
              _screens[_selectedIndex],

              /// Fader Effect
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppFaderEffect(atBottom: _atBottom),
              ),

              /// Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AppBBN(onChangeScreen: _onItemTapped),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar
  AppBar _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sportifind',
            style: SportifindTheme.sportifindAppBar,
          ),
          Stack(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(
                        userNoti: userNoti,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_none,
                  size: 35,
                  color: SportifindTheme.bluePurple,
                ),
              ),
              userNoti.any((noti) => noti.isRead == false)
                  ? const Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Icon(Icons.brightness_1_rounded,
                          size: 16.0, color: Color.fromARGB(255, 255, 0, 0)),
                    )
                  : const SizedBox(),
              userNoti.any((noti) => noti.isRead == false)
                  ? const Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Icon(Icons.brightness_1_outlined,
                          size: 16.0, color: Colors.white),
                    )
                  : const SizedBox(),
            ],
          ),
          Stack(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatMainScreen(),
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
                top: 6.0,
                right: 6.0,
                child: Icon(Icons.brightness_1_rounded,
                    size: 16.0, color: Color.fromARGB(255, 255, 0, 0)),
              ),
              const Positioned(
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
    );
  }
}