import 'package:flutter/material.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/presentation/widgets/match_list_item.dart';


class MatchCardList extends StatelessWidget {
  const MatchCardList({super.key, required this.matches, required this.status});

  final List<MatchEntity> matches;
  final int status;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: matches.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (ctx, index) => MatchListItem(
        matchCard: matches[index],
        status: status,
      ),
    );
  }
}
