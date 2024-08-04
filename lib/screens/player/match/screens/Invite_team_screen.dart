import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/widgets/team_list/team_cards.dart';

class InviteTeamScreen extends StatefulWidget {
  const InviteTeamScreen({super.key, required this.matchInfo});

  final MatchCard matchInfo;

  @override
  State<StatefulWidget> createState() => _InviteTeamScreenState();
}

class _InviteTeamScreenState extends State<InviteTeamScreen> {
  List<TeamInformation> team = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          TeamCards(
            otherTeam: team,
            hostId: widget.matchInfo.team1,
            matchId: widget.matchInfo.id,
          ),
        ],
      ),
    );
  }
}
