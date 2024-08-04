import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/object_handling.dart';
import 'package:sportifind/util/user_service.dart';

class TeamListItem extends StatefulWidget {
  const TeamListItem(
      {super.key,
      required this.team,
      required this.hostId,
      required this.matchId});

  final TeamInformation team;
  final String hostId;
  final String matchId;

  @override
  State<StatefulWidget> createState() => _TeamListItemState();
}

class _TeamListItemState extends State<TeamListItem> {
  final user = FirebaseAuth.instance.currentUser!;
  late ImageProvider teamImageProvider;
  UserService userService = UserService();
  MatchHandling matchHandling = MatchHandling();

  TeamInformation? teamWithCaptainName;

  Future<TeamInformation> convertTeamIdToName(TeamInformation team) async {
    final userMap = await userService.generateUserMap();
    team.captain = userMap[team.captain] ?? 'Unknown Player';
    return team;
  }

  Future<void> preloadImage() async {
    teamImageProvider = NetworkImage(widget.team.avatarImageUrl);
    await precacheImage(teamImageProvider, context);
    teamWithCaptainName = await convertTeamIdToName(widget.team);
  }

  @override
  Widget build(BuildContext context) {
    print(teamWithCaptainName);
    return FutureBuilder(
      future: preloadImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Card(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: teamImageProvider,
                    ),
                    Column(
                      children: [
                        Text(teamWithCaptainName!.name),
                        Text(teamWithCaptainName!.captain),
                        Row(
                          children: [
                            Text("${teamWithCaptainName!.address}, "),
                            Text("${teamWithCaptainName!.district}, "),
                            Text(teamWithCaptainName!.city),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  child: TextButton(
                      onPressed: () {
                        print("Push notification");
                        print(widget.team.teamId);
                        matchHandling.inviteMatchRequest(
                            widget.hostId, widget.team.teamId, widget.matchId);
                      },
                      child: Text("Invite")),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
