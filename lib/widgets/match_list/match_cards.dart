import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match_management/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/match_management/screens/select_stadium_screen.dart';
import 'package:sportifind/widgets/match_list/match_list.dart';

import '../../models/match_card.dart';

// Test Data for displaying match card

final List<MatchCard> _nearByMatch = [];

class MatchCards extends StatefulWidget {
  const MatchCards({super.key});

  @override
  State<StatefulWidget> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  final user = FirebaseAuth.instance.currentUser!;
  final List<MatchCard> _yourMatch = [];

  void _addMatchCard(MatchCard matchcard) {
    setState(() {
      _yourMatch.add(matchcard);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MatchMainScreen(),
        ),
      );
    });
  }

  void getMatchData() async {
    final List<MatchCard> userMatches = [];
    final matchesQuery =
        await FirebaseFirestore.instance.collection('matches').get();
    final matches = matchesQuery.docs
        .map((match) => MatchCard.fromSnapshot(match))
        .toList();
    for (var i = 0; i < matches.length; ++i) {
      if (matches[i].userId == user.uid) {
        userMatches.add(matches[i]);
      }
    }
    setState(() {
      _yourMatch.addAll(userMatches);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getMatchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height - 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Your match",
              style: SportifindTheme.display1,
            ),
          ),
          const SizedBox(height: 20),
          MatchCardList(matches: _yourMatch),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Nearby match",
              style: SportifindTheme.display1,
            ),
          ),
          const SizedBox(height: 20),
          MatchCardList(matches: _nearByMatch),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.only(left: 360.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectStadiumScreen(addMatchCard: _addMatchCard),
                  ),
                );
              },
              backgroundColor: SportifindTheme.nearlyDarkGreen,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: SportifindTheme.white,),
            ),
          ),
        ],
      ),
    );
  }
}
