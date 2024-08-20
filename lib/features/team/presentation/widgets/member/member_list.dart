import 'package:flutter/material.dart';
import 'package:sportifind/features/team/presentation/widgets/member/member_list_item.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';


class MemberList extends StatelessWidget {
  const MemberList({super.key, required this.team, required this.status});

  final TeamEntity team;
  final int status;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: team.players.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (ctx, index) => MemberListItem(
        member: team.players[index],
        team: team,
        status: status,
        number: index,
      ),
    );
  }
}
