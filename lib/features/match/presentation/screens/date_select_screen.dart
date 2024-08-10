import 'package:flutter/material.dart';
import 'package:sportifind/features/auth/presentations/widgets/cards/match_card.dart';
import 'package:sportifind/features/stadium/domain/entities/field.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.selectedStadiumId,
      required this.selectedStadiumName,
      required this.selectedStadiumOwner,
      required this.selectedTeamId,
      required this.selectedTeamName,
      required this.selectedTeamAvatar,
      required this.fields,
      required this.addMatchCard});

  final String selectedTeamId;
  final String selectedTeamName;
  final String selectedTeamAvatar;
  final String selectedStadiumId;
  final String selectedStadiumName;
  final String selectedStadiumOwner;
  final List<Field> fields;
  final void Function(MatchCard matchcard)? addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}


class _DateSelectScreenState extends State<DateSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date'),
      ),
    );
  } 
}
