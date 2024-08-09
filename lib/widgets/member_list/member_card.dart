import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/widgets/member_list/member_list.dart';
import '../../models/match_card.dart';

// ignore: must_be_immutable
class MemberCards extends StatefulWidget {
  const MemberCards({
    super.key,
    required this.status,
    required this.matchInfo,
  });

  final int status;
  final MatchCard matchInfo;

  @override
  State<StatefulWidget> createState() => _MemberCardsState();
}

class _MemberCardsState extends State<MemberCards> {
  final user = FirebaseAuth.instance.currentUser!;
  TeamService teamService = TeamService();
  TeamInformation? homeTeam;
  TeamInformation? awayTeam;
  bool isLoadingUser = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant MemberCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.status == widget.status) {
      _refreshData();
    }
  }

  Future<void> fetchData() async {
    try {
      _loadMatchData();
    } catch (error) {
      print('Failed to load data: $error');
    }
  }

  Future<void> _loadMatchData() async {
    if (widget.status == 0) {
      homeTeam = await teamService.getTeamInformation(widget.matchInfo.team1);
    } else {
      awayTeam = await teamService.getTeamInformation(widget.matchInfo.team2);
    }

    setState(() {
      isLoadingUser = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoadingUser = true;
      errorMessage = '';
    });
    await _loadMatchData();
  }

  Widget buildMatch(TeamInformation memberId) {
    print(memberId);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 280,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MemberList(
          memberId: memberId,
          status: widget.status,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.status == 0 && homeTeam != null) {
      return SingleChildScrollView(
        child: buildMatch(homeTeam!),
      );
    } else if (widget.status == 1 && awayTeam != null) {
      return SingleChildScrollView(
        child: buildMatch(awayTeam!),
      );
    } else if (widget.status == 1 && awayTeam == null) {
      return const Center(
        child: Text("Please Invite other team first ^_^"),
      );
    } else if (widget.status == 0 && homeTeam == null) {
      return const Center(
        child: Text("Please join this match first ^_^"),
      );
    } else {
      return const SizedBox();
    }
  }
}
