import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/player_details.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/util/search_service.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/dropdown_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/widgets/my_teams_listview.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/object_handling.dart';

class PlayerList extends StatelessWidget {
  const PlayerList(
      {super.key,
      required this.members,
      required this.type,
      required this.team});
  final List<PlayerData> members;
  final String type;
  final TeamInformation? team;

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
  final PlayerData player;
  final int stt;
  final String type;
  final TeamInformation? team;

  @override
  Widget build(BuildContext context) {
    TeamHandling teamHandling = TeamHandling();

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
              backgroundImage: NetworkImage(player.avatarImage),
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
                            teamHandling.removePlayerFromTeam(
                              team!.teamId,
                              player.id,
                              'kicked',
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
