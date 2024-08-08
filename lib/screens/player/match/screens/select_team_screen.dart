import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/object_handling.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({
    super.key,
    this.addMatchCard,
    this.forMatchCreate = true,
    this.forJoinRequest = false,
    this.hostId,
    this.matchId,
  });

  final void Function(MatchCard matchcard)? addMatchCard;
  final bool forMatchCreate;
  final bool forJoinRequest;
  final String? hostId;
  final String? matchId;

  @override
  State<StatefulWidget> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  UserService userService = UserService();
  TeamService teamService = TeamService();
  MatchHandling matchHandling = MatchHandling();

  PlayerData? user;
  List<TeamInformation> userTeams = [];

  Future<void> fetchingData() async {
    if (widget.forMatchCreate == true || widget.forJoinRequest == true) {
      user = await userService.getUserPlayerData();
      for (var i = 0; i < user!.teams.length; ++i) {
        final team = await teamService.getTeamInformation(user!.teams[i]);
        userTeams.add(team!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Team"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/assets/images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<void>(
                future: fetchingData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading teams'));
                  } else if (userTeams.isNotEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 230,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: userTeams.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (ctx, index) {
                              return makeTeamItem(userTeams[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No teams available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeTeamItem(TeamInformation team) {
    return GestureDetector(
      onTap: () {
        if (widget.forMatchCreate == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerStadiumScreen(
                forMatchCreate: true,
                selectedTeamId: team.teamId,
                selectedTeamName: team.name,
                selectedTeamAvatar: team.avatarImageUrl,
                addMatchCard: widget.addMatchCard,
              ),
            ),
          );
        } else if (widget.forJoinRequest == true) {
          matchHandling.joinMatchRequest(
              team.teamId, widget.hostId, widget.matchId);
        }
      },
      child: Container(
        height: 100,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: SportifindTheme.bluePurple, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: SportifindTheme.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                team.name,
                style: const TextStyle(
                  color: SportifindTheme.bluePurple,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: SportifindTheme.bluePurple,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${team.district}, ${team.city}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Maximum number of lines for the text
                      overflow: TextOverflow
                          .clip, // Add ellipsis (...) if text overflows
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.group_outlined,
                    color: SportifindTheme.bluePurple,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${team.members.length} members",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 25,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: SportifindTheme.bluePurple,
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Pick this team",
                      style: TextStyle(
                        color: SportifindTheme.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
