import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/features/profile/domain/entities/player_entity.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/domain/usecases/kick_player.dart';
import 'package:sportifind/features/team/presentation/screens/player_details.dart';

class PlayerList extends StatelessWidget {
  const PlayerList(
      {super.key,
      required this.members,
      required this.team,
      required this.role});
  final List<PlayerEntity> members;
  final TeamEntity? team;
  final String role;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          members.length,
          (index) => PlayerBox(
            role: role,
            team: team,
            player: members[index], // Pass the player data
            stt: index + 1, // Pass the index as the serial number
          ),
        ),
      ),
    );
  }
}

class PlayerBox extends StatelessWidget {
  const PlayerBox(
      {super.key,
      required this.player,
      required this.stt,
      required this.team,
      required this.role});
  final PlayerEntity player;
  final int stt;
  final TeamEntity? team;
  final String role;

  int get age {
    String dob = player.dob;
    // dd/mm/yyyy get month,day, year and calculate age
    int year = int.parse(dob.substring(6, 10));
    int month = int.parse(dob.substring(3, 5));
    int day = int.parse(dob.substring(0, 2));
    DateTime now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  // check if this viewer is view thei

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Text(
              stt.toString(),
              style: SportifindTheme.normalTextBlack.copyWith(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(player.avatar.path),
            ),
            const SizedBox(width: 11),
            SizedBox(
              width: 296,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        player.name,
                        style: SportifindTheme.normalTextBlack.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      (role == 'other' || role == 'member')
                          ? TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerDetails(
                                      user: player,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'View profile',
                                style: SportifindTheme.normalTextBlack.copyWith(
                                  fontSize: 14,
                                  color: SportifindTheme.bluePurple
                                      .withOpacity(0.9),
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.more_vert),
                              iconSize: 20,
                              onPressed: () {
                                _showCaptainOption(context);
                              },
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Age',
                        style: SportifindTheme.normalTextBlack.copyWith(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        ' $age',
                        style: SportifindTheme.normalTextBlack.copyWith(
                          fontSize: 15,
                          color: SportifindTheme.bluePurple.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCaptainOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: SportifindTheme.bluePurple, width: 2.0),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Choose an Option',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: SportifindTheme.bluePurple,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.edit, color: SportifindTheme.bluePurple),
                  title: Text(
                    'View profile',
                    style: SportifindTheme.normalTextBlack.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PlayerDetails(
                          user: player,
                        ),
                      ),
                    );
                    // Handle the edit action
                    //Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Moving to ${player.name} profile'),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.delete_outline,
                      color: Colors.red.withOpacity(0.9)),
                  title: Text(
                    'Kick Player',
                    style: SportifindTheme.normalTextBlack.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    UseCaseProvider.getUseCase<KickPlayer>().call(
                      KickPlayerParams(
                        team: team!,
                        player: player,
                        type: 'kick',
                      ),
                    );
                    // dialog informing player has been removed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Player removed'),
                          content: Text(
                              'Player ${player.name} has been removed from the team'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
