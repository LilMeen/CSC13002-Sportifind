import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/widgets/team_list/team_list.dart';

// ignore: must_be_immutable
class TeamCards extends StatefulWidget {
  TeamCards({super.key, required this.otherTeam, required this.hostId, required this.matchId});

  List<TeamInformation> otherTeam;
  final String hostId;
  String matchId;

  @override
  State<StatefulWidget> createState() => _TeamCardsState();
}

class _TeamCardsState extends State<TeamCards> {
  final user = FirebaseAuth.instance.currentUser!;
  TeamService teamService = TeamService();
  late ImageProvider team1ImageProvider;
  late Future<void> initializationFuture;

  Future<void> _initialize() async {
    final teamNames = await teamService.getTeamData();
    for (var i = 0; i < teamNames.length; ++i) {
      if (teamNames[i].captain == user.uid) {
        continue;
      }
      widget.otherTeam.add(teamNames[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _initialize(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          print(widget.matchId);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height - 150,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TeamInformationList(
                      teams: widget.otherTeam,
                      hostId: widget.hostId,
                      matchId: widget.matchId,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
