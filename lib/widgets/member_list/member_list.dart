import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/widgets/member_list/member_list._tem.dart';

class MemberList extends StatelessWidget {
  const MemberList({super.key, required this.memberId, required this.status});

  final TeamInformation memberId;
  final int status;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: memberId.members.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (ctx, index) => MemberListItem(
        memberId: memberId.members[index],
        team: memberId,
        status: status,
        number: index,
      ),
    );
  }
}
