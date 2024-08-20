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
      required this.type,
      required this.team});
  final List<PlayerEntity> members;
  final String type;
  final TeamEntity? team;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          members.length,
          (index) => PlayerBox(
            team: team,
            player: members[index], // Pass the player data
            stt: index + 1,
            type: type, // Pass the index as the serial number
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
      required this.type,
      required this.team});
  final PlayerEntity player;
  final int stt;
  final String type;
  final TeamEntity? team;

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
                      TextButton(
                        onPressed: () {
                          if (type == 'view') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerDetails(
                                  user: player,
                                  role: 'other',
                                ),
                              ),
                            );
                          } else {
                            // Remove player from team
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
                                  title: const Text('Player  removed'),
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
                          }
                        },
                        child: Text(
                          type == 'view' ? 'View profile' : 'Remove',
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 14,
                            color: type == 'view'
                                ? SportifindTheme.bluePurple.withOpacity(0.9)
                                : Colors.red.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'testlater years',
                        style: SportifindTheme.normalTextBlack.copyWith(
                          fontSize: 15,
                          color: Colors.grey,
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
}
