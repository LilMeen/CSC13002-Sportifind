import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/screens/team_details.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key, required this.teams});
  final List<TeamEntity?> teams;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          teams.length,
          (index) => TeamBox(
            team: teams[index], // Pass the team data
            stt: index + 1, // Pass the index as the serial number
          ),
        ),
      ),
    );
  }
}

class TeamBox extends StatelessWidget {
  const TeamBox({super.key, required this.team, required this.stt});
  final TeamEntity? team;
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
              backgroundImage: NetworkImage(team!.avatar.path),
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
                                teamId: team!.id,
                                role: 'teamMember',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'View team',
                          style: SportifindTheme.normalTextBlack.copyWith(
                              fontSize: 14,
                              color:
                                  SportifindTheme.bluePurple.withOpacity(0.9)),
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
