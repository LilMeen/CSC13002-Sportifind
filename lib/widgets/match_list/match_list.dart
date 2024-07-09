import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/widgets/match_list/match_list_item.dart';

class MatchCardList extends StatelessWidget {
  const MatchCardList({super.key, required this.matches});

  final List<MatchCard> matches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: matches.length,
      itemBuilder: (ctx, index) => MatchListItem(
        matchCard: matches[index],
      ),
    );
  }
}
