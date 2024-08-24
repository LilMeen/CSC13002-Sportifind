import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/match_info_screen.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';

class MatchListItem extends StatefulWidget {
  const MatchListItem(
      {super.key, required this.matchCard, required this.status});

  final MatchCard matchCard;
  final int status;

  @override
  State<StatefulWidget> createState() => _MatchListItemState();
}

class _MatchListItemState extends State<MatchListItem> {
  String? teamName;
  MatchService matchService = MatchService();
  TeamService teamService = TeamService();
  StadiumService stadiumService = StadiumService();
  bool isLoadingUser = true;
  Map<String, String> teamNames = {};
  Map<String, String> stadiumNames = {};

  Future<void> _initialize() async {
    teamNames = await teamService.generateTeamNameMap();
    stadiumNames = await stadiumService.generateStadiumMap();

    setState(() {
      isLoadingUser = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = matchService.parseDate(widget.matchCard.date);
    Map<int, String> month = {
      1: "JAN",
      2: "FEB",
      3: "MAR",
      4: "APR",
      5: "MAY",
      6: "JUNE",
      7: "JULY",
      8: "AUG",
      9: "SEP",
      10: "OCT",
      11: "NOV",
      12: "DEC"
    };
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchInfoScreen(
              matchInfo: widget.matchCard,
              matchStatus: widget.status,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 50,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${date.day}\n",
                    style: SportifindTheme.matchMonthDisplay,
                    children: [
                      TextSpan(
                        text: month[date.month]!,
                        style: SportifindTheme.matchDateDisplay,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              height: 210,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: widget.status == 0
                      ? const AssetImage('lib/assets/images/match.jpg')
                      : const AssetImage('lib/assets/images/matchNearby.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            teamNames[widget.matchCard.team1] ?? "Unknown",
                            textAlign: TextAlign.center,
                            style: SportifindTheme.matchCardItem,
                            maxLines: 1, // Maximum number of lines for the text
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis (...) if text overflows
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 35,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "VS",
                          style: SportifindTheme.matchVS,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            teamNames[widget.matchCard.team2] ?? "Unknown",
                            style: SportifindTheme.matchCardItem,
                            maxLines: 1, // Maximum number of lines for the text
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis (...) if text overflows
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 35,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.matchCard.start,
                        style: SportifindTheme.matchCardItem,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      const Icon(
                        Icons.hourglass_top_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.matchCard.playTime,
                        style: SportifindTheme.matchCardItem,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      const Icon(
                        Icons.stadium,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          stadiumNames[widget.matchCard.stadium] ?? "Unknow",
                          style: SportifindTheme.matchCardItem,
                          maxLines: 1, // Maximum number of lines for the text
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis (...) if text overflows
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
