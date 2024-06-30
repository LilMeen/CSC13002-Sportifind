import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class MatchListItem extends StatelessWidget {
  const MatchListItem({super.key, required this.matchCard});

  final MatchCard matchCard;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("I was tapped"),
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: SportifindTheme.matchCard,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: roundedRectangleBuilder(320, matchCard.stadium, false,
                      SportifindTheme.nearlyGreen)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      profileBuilder(40, matchCard.avatarTeam1),
                      const SizedBox(height: 4),
                      Text(
                        matchCard.team1,
                        style: SportifindTheme.title,
                      ),
                    ],
                  ),
                  const Text(
                    "VS",
                    style: TextStyle(fontSize: 40),
                  ),
                  Column(
                    children: [
                      profileBuilder(40, matchCard.avatarTeam2),
                      const SizedBox(height: 4),
                      Text(
                        matchCard.team2,
                        style: SportifindTheme.title,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: SportifindTheme.background,
                thickness: 4,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  roundedRectangleBuilder(80, matchCard.startHour, false,
                      SportifindTheme.nearlyWhite),
                  roundedRectangleBuilder(120, matchCard.formattedDate, false,
                      SportifindTheme.nearlyWhite),
                  roundedRectangleBuilder(80, matchCard.playTime, true,
                      SportifindTheme.nearlyWhite),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget profileBuilder(double radius, String avatar) {
  return CircleAvatar(
    radius: radius,
    child: ClipOval(
      child: Image(
        image: AssetImage(avatar),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      ),
    ),
  );
}

Widget roundedRectangleBuilder(
    double width, String text, bool withIcon, Color color) {
  return Container(
    width: width,
    height: 30,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: (withIcon == true)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_alarm,
                size: 20,
              ),
              Text(
                text,
                style: SportifindTheme.title,
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: SportifindTheme.title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
  );
}
