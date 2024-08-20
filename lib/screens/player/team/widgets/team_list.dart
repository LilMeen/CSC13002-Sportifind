import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_details.dart';
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

class TeamList extends StatelessWidget {
  const TeamList({super.key, required this.teams});
  final List<TeamInformation?> teams;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teams.length, // Assuming team has a list of players
      itemBuilder: (context, index) {
        return TeamBox(
          team: teams[index], // Pass the player data
          stt: index + 1, // Pass the index as the serial number
        );
      },
    );
  }
}

class TeamBox extends StatelessWidget {
  const TeamBox(
      {super.key, required this.team, required this.stt});
  final TeamInformation? team;
  final int stt;

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
              backgroundImage: NetworkImage(team!.avatarImageUrl),
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
                        team!.name,
                        style: SportifindTheme.normalTextBlack.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                        
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamDetails(
                                  teamId: team!.teamId,
                                  role: 'teamMember',
                                ),
                              ),
                            );
                        },
                        child: Text(
                          'View team' ,
                          style: SportifindTheme.normalTextBlack.copyWith(
                            fontSize: 14,
                            color: 
                                SportifindTheme.bluePurple.withOpacity(0.9)
                                
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${team!.location.district}, ${team!.location.city}',
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
