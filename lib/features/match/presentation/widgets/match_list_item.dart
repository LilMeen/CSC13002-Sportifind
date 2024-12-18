// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/datetime_util.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/presentation/screens/match_info_screen.dart';

class MatchListItem extends StatefulWidget {
  const MatchListItem(
      {super.key, required this.matchCard, required this.status});

  final MatchEntity matchCard;
  final int status;

  @override
  State<StatefulWidget> createState() => _MatchListItemState();
}

class _MatchListItemState extends State<MatchListItem> {
  ImageProvider? team1ImageProvider;
  ImageProvider? team2ImageProvider;
  IconData? dummyIcon;
  bool isLoadingUser = true;

  Future<void> _initialize() async {
    team1ImageProvider = NetworkImage(widget.matchCard.team1.avatar.path);
    if (widget.matchCard.team2 != null) {
      team2ImageProvider = NetworkImage(widget.matchCard.team2!.avatar.path);
    } else {
      dummyIcon = Icons.question_mark;
    }

    await precacheImage(team1ImageProvider!, context);
    if (team2ImageProvider != null) {
      await precacheImage(team2ImageProvider!, context);
    }

    if (!mounted) {
      return; // Ensure the widget is still mounted before calling setState
    }
    setState(() {
      isLoadingUser = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Schedule _initialize to run after the first frame is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = parseDate(widget.matchCard.date);
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
          SizedBox(
            width: 50,
            height: 170,
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            Text(
                              widget.matchCard.team1.name,
                              textAlign: TextAlign.center,
                              style: SportifindTheme.matchCardItem,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: team1ImageProvider,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "VS",
                          style: SportifindTheme.matchVS,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              widget.matchCard.team2?.name ?? "Unknown",
                              style: SportifindTheme.matchCardItem,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: widget.matchCard.team2 != null
                                  ? CircleAvatar(
                                      radius: 35,
                                      backgroundImage: team2ImageProvider,
                                    )
                                  : Icon(
                                      dummyIcon,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(Icons.access_time, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        widget.matchCard.start,
                        style: SportifindTheme.matchCardItem,
                      ),
                      const SizedBox(width: 40),
                      const Icon(Icons.hourglass_top_rounded,
                          color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        widget.matchCard.playTime,
                        style: SportifindTheme.matchCardItem,
                      ),
                      const SizedBox(width: 40),
                      const Icon(Icons.stadium, color: Colors.white),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.matchCard.stadium.name,
                          style: SportifindTheme.matchCardItem,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
