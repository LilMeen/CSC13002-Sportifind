import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/create_team_form.dart';
import 'package:sportifind/util/match_service.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({super.key, required this.addMatchCard});

  final void Function(MatchCard matchcard) addMatchCard;

  @override
  State<StatefulWidget> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  MatchService matchService = MatchService();
  
  Future<List<TeamInformation>>? team;

  @override
  void initState() {
    super.initState();
    print("Fetching data");
    team = matchService.getTeamData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: FutureBuilder<List<TeamInformation>>(
                  future: team,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading teams'));
                    } else if (snapshot.hasData) {
                      final teams = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: 250,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: teams.length + 1,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemBuilder: (ctx, index) {
                                if (index < teams.length) {
                                  return makeTeamItem(teams[index]);
                                } else {
                                  return createTeamCard();
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerStadiumScreen(
              forMatchCreate: true,
              selectedTeam: team.name,
              addMatchCard: widget.addMatchCard,
            ),
          ),
        );
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
