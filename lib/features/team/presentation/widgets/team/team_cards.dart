import 'package:flutter/material.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/widgets/team/team_information_list.dart';

// ignore: must_be_immutable
class TeamCards extends StatefulWidget {
  TeamCards(
      {super.key,
      required this.otherTeam,
      required this.hostId,
      required this.matchId});

  List<TeamEntity> otherTeam;
  final String hostId;
  String matchId;

  @override
  State<StatefulWidget> createState() => _TeamCardsState();
}

class _TeamCardsState extends State<TeamCards> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TeamInformationList(
          teams: widget.otherTeam,
          hostId: widget.hostId,
          matchId: widget.matchId,
        ),
      ),
    );
  }
}
