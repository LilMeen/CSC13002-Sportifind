import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/widgets/search_bar.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/screens/player/team/widgets/my_teams_listview.dart';
import 'package:sportifind/screens/player/team/widgets/nearby_teams_listview.dart';
import 'package:sportifind/screens/player/team/screens/create_team_form.dart';

class TeamMainScreen extends StatefulWidget {
  const TeamMainScreen({super.key});

  @override
  State<TeamMainScreen> createState() => _TeamMainScreenState();
}

class _TeamMainScreenState extends State<TeamMainScreen> {
  void callBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SportifindTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            const SportifindAppBar(title: 'Sportifind'),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      const SportifindSearchBar(),
                      getMyTeamListview(),
                      Flexible(
                        child: getNearbyTeamListView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMyTeamListview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your teams',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: SportifindTheme.darkerText,
                ),
              ),
              TextButton(
                child:  Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: SportifindTheme.bluePurple1,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Create Team',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.27,
                        color: SportifindTheme.bluePurple1,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateTeamForm()));
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: MyTeamsListView(
            callBack: callBack,
          ),
        ),
      ],
    );
  }

  Widget getNearbyTeamListView() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Nearby Teams',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: SportifindTheme.darkerText,
            ),
          ),
          Flexible(
            child: NearbyTeamListView(
              callBack: callBack,
            ),
          )
        ],
      ),
    );
  }
}
