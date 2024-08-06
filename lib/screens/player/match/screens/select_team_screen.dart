import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/create_team_form.dart';
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
                  'lib/assets/images/bg.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.3),
                  ],
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
                            height: 250,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: userTeams.length + 1,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemBuilder: (ctx, index) {
                                if (index < userTeams.length) {
                                  print(userTeams[index].teamId);
                                  print(widget.hostId);
                                  return makeTeamItem(userTeams[index]);
                                }
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
      child: AspectRatio(
        aspectRatio: 1.9 / 2,
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(team.avatarImageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
            color: Colors.grey.shade900,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black26,
                    ),
                    child: Text(
                      team.address,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                team.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createTeamCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTeamForm()),
        );
      },
      child: AspectRatio(
        aspectRatio: 1 / 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade900,
          ),
          child: Center(
              child: Icon(
            Icons.add,
            color: Colors.yellow[700],
            size: 50,
          )),
        ),
      ),
    );
  }
}
