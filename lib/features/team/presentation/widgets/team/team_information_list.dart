import 'package:flutter/material.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/widgets/team/team_list_item.dart';

class TeamInformationList extends StatelessWidget {
  const TeamInformationList(
      {super.key,
      required this.teams,
      required this.hostId,
      required this.matchId});

  final List<TeamEntity> teams;
  final String hostId;
  final String matchId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: teams.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (ctx, index) => TeamListItem(
        team: teams[index],
        hostId: hostId,
        matchId: matchId,
      ),
    );
  }
}
