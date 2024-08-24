import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/screens/player_details.dart';

class MemberListItem extends StatefulWidget {
  const MemberListItem({
    super.key,
    required this.member,
    required this.team,
    required this.status,
    required this.number,
  });

  final PlayerEntity member;
  final TeamEntity team;
  final int status;
  final int number;

  @override
  State<StatefulWidget> createState() => _MemberListItemState();
}

class _MemberListItemState extends State<MemberListItem> {
  ImageProvider? team1ImageProvider;
  PlayerEntity? playerData;
  bool isLoadingUser = true;
  Map<String, String> teamNames = {};
  Map<String, String> stadiumNames = {};

  @override
  void initState() {
    super.initState();
    playerData = widget.member;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeImage();
  }

  Future<void> _initializeImage() async {
    team1ImageProvider = NetworkImage(playerData!.avatar.path);
    await precacheImage(team1ImageProvider!, context);
    setState(() {
      isLoadingUser = false;
    });
  }

  bool isCaptain() {
    return widget.team.captain.id == widget.member.id;
  }

  int calculateAge(String dobString) {
    DateFormat dateFormat =
        DateFormat('dd/MM/yyyy'); // Ensure format is correct
    DateTime dob = dateFormat.parse(dobString);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return const SizedBox();
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              widget.number.toString(),
              style: const TextStyle(
                  color: SportifindTheme.smokeScreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 20),
          Stack(
            children: [
              isCaptain()
                  ? const Icon(
                      Icons.stacked_bar_chart,
                    )
                  : const SizedBox(),
              CircleAvatar(
                radius: 35,
                backgroundImage: team1ImageProvider,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerData!.name,
                  style: SportifindTheme.memberItem,
                ),
                Text(
                  "${calculateAge(playerData!.dob)}y",
                  style: SportifindTheme.yearOld,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerDetails(
                      user: playerData!,
                      role: "other",
                    ),
                  ),
                );
              },
              child: Text(
                "view profile",
                style: SportifindTheme.viewProfileDetails,
              ),
            ),
          ),
        ],
      );
    }
  }
}
