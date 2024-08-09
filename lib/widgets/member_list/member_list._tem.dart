import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/user_service.dart';

class MemberListItem extends StatefulWidget {
  const MemberListItem({
    super.key,
    required this.memberId,
    required this.team,
    required this.status,
    required this.number,
  });

  final String memberId;
  final TeamInformation team;
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
    team1ImageProvider = NetworkImage(playerData!.avatarImage);
    await precacheImage(team1ImageProvider!, context);
    setState(() {
      isLoadingUser = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  bool isCaptain() {
    if (widget.team.captain == widget.memberId) {
      return true;
    } else {
      return false;
    }
  }

  int calculateAge(String dobString) {
    // Define the format in which the dob string is stored
    DateFormat dateFormat = DateFormat('dd/mm/yyyy'); // Adjust format as needed

    // Parse the string into a DateTime object
    DateTime dob = dateFormat.parse(dobString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the age
    int age = currentDate.year - dob.year;

    // Adjust if the player's birthday hasn't occurred yet this year
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser == true) {
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
                  color: SportifindTheme.smokeScreen, fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Stack(
            children: [
              isCaptain() == true
                  ? const Icon(Icons.headphones_battery)
                  : const SizedBox(),
              CircleAvatar(
                radius: 35,
                backgroundImage: team1ImageProvider,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
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
              onTap: () {},
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
