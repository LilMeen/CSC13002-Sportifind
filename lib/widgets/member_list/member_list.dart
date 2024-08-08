import 'package:flutter/material.dart';
import 'package:sportifind/widgets/match_list/match_list_item.dart';
import 'package:sportifind/widgets/member_list/member_list._tem.dart';

class MemberList extends StatelessWidget {
  const MemberList({super.key, required this.memberId, required this.status});

  final List<String> memberId;
  final int status;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: memberId.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (ctx, index) => MemberListItem(
        memberId: memberId[index],
        status: status,
        number: index,
      ),
    );
  }
}
