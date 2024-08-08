import 'package:flutter/material.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';

class MemberListItem extends StatefulWidget {
  const MemberListItem({
    super.key,
    required this.memberId,
    required this.status,
    required this.number,
  });

  final String memberId;
  final int status;
  final int number;

  @override
  State<StatefulWidget> createState() => _MemberListItemState();
}

class _MemberListItemState extends State<MemberListItem> {
  UserService userService = UserService();
  StadiumService stadiumService = StadiumService();
  ImageProvider? team1ImageProvider;
  PlayerData? playerData;
  bool isLoadingUser = true;
  Map<String, String> teamNames = {};
  Map<String, String> stadiumNames = {};

  Future<void> _initialize() async {
    playerData = await userService.getPlayerData(widget.memberId);

    team1ImageProvider = NetworkImage(playerData!.avatarImageUrl);
    await precacheImage(team1ImageProvider!, context);
    setState(() {
      isLoadingUser = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser == true) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Row(
            children: [
              CircleAvatar(),
              Column(
                children: [
                  Text(playerData!.name),
                  Text(playerData!.dob),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text("view profile"),
              )
            ],
          ),
        ],
      );
    }
  }
}
