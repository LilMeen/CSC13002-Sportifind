import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/usecases/usecase.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/chat/presentation/widgets/group_tile.dart';
import 'package:sportifind/features/profile/domain/usecases/get_current_profile.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/get_team_by_player.dart';
import 'package:sportifind/features/user/domain/entities/user_entity.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});
  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen>
    with TickerProviderStateMixin {
  List<TeamEntity> myTeams = [];
  AnimationController? animationController;
  late UserEntity user;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _initialize();
  }

  Future<void> _initialize() async {
    myTeams = await UseCaseProvider.getUseCase<GetTeamByPlayer>()
        .call(GetTeamByPlayerParams(
            playerId: FirebaseAuth.instance.currentUser!.uid))
        .then((value) => value.data ?? []);
    user = await UseCaseProvider.getUseCase<GetCurrentProfile>()
        .call(NoParams())
        .then((value) => value.data!);
    setState(() {});
  }

  bool isNotJoined(String team, List<String> joinedTeams) {
    return !joinedTeams.any((element) => element == team);
  }

  Widget noGroupWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {},
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            const SizedBox(height: 20.0),
            const Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget teamList() {
    return ListView.builder(
      itemCount: myTeams.length,
      itemBuilder: (context, index) {
        final team = myTeams[index];
        return GroupChatTile(team: team, currentUser: user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Messages',
          style: SportifindTheme.sportifindAppBarForFeature.copyWith(
            fontSize: 32,
            color: SportifindTheme.bluePurple,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: SportifindTheme.bluePurple),
        elevation: 0,
        surfaceTintColor: SportifindTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: teamList(),
    );
  }
}
