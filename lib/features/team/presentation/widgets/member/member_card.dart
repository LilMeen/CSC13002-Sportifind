import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/team/presentation/widgets/member/member_list.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

// ignore: must_be_immutable
class MemberCards extends StatefulWidget {
  const MemberCards({
    super.key,
    required this.status,
    required this.matchInfo,
  });

  final int status;
  final MatchEntity matchInfo;

  @override
  State<StatefulWidget> createState() => _MemberCardsState();
}

class _MemberCardsState extends State<MemberCards> {
  final user = FirebaseAuth.instance.currentUser!;
  TeamEntity? homeTeam;
  TeamEntity? awayTeam;
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
      throw ('Failed to load data: $error');
    }
  }

  Future<void> _loadMatchData() async {
    if (widget.status == 0) {
      homeTeam = widget.matchInfo.team1;
    } else {
      awayTeam = widget.matchInfo.team2;
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

  Widget buildMatch(TeamEntity team) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MemberList(
          team: team,
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
      return Center(
        child: Text(
          "Please Invite other team first ^_^",
          style: SportifindTheme.body,
        ),
      );
    } else if (widget.status == 0 && homeTeam == null) {
      return Center(
        child: Text(
          "Please join this match first ^_^",
          style: SportifindTheme.body,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
