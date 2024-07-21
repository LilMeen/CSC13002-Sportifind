import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/widgets/match_list/match_list.dart';

import '../../models/match_card.dart';

class MatchCards extends StatefulWidget {
  const MatchCards(
      {super.key, required this.yourMatch, required this.nearByMatch});

  final List<MatchCard> yourMatch;
  final List<MatchCard> nearByMatch;

  @override
  State<StatefulWidget> createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  final user = FirebaseAuth.instance.currentUser!;

  void _openFilterOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const Text("hhehehehe"),
    );
  }

  void getPersonalMatchData() async {
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
      widget.yourMatch.addAll(userMatches);
    });
  }

  void getNearbyMatchData() async {
    final List<MatchCard> userMatches = [];

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final matchesQuery =
        await FirebaseFirestore.instance.collection('matches').get();
    final matches = matchesQuery.docs
        .map((match) => MatchCard.fromSnapshot(match))
        .toList();

    final stadiumsQuery =
        await FirebaseFirestore.instance.collection('stadiums').get();
    final stadiums = stadiumsQuery.docs
        .map((stadium) => StadiumData.fromSnapshot(stadium))
        .toList();

    for (var i = 0; i < stadiums.length; ++i) {
      for (var j = 0; j < matches.length; ++j) {
        if (matches[j].stadium == stadiums[i].name &&
            stadiums[i].location.city == userData.data()!['city'] &&
            stadiums[i].location.district == userData.data()!['district'] &&
            matches[j].userId != user.uid) {
              userMatches.add(matches[j]);
            }
      }
      setState(() {
        widget.nearByMatch.addAll(userMatches);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getPersonalMatchData();
      getNearbyMatchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          SizedBox(
            height: 240,
            child: MatchCardList(matches: widget.yourMatch),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Nearby match",
                  style: SportifindTheme.display1,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      _openFilterOverlay();
                    },
                    icon: const Icon(
                      Icons.filter_alt,
                      color: SportifindTheme.nearlyGreen,
                      size: 40,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: MatchCardList(matches: widget.nearByMatch),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
