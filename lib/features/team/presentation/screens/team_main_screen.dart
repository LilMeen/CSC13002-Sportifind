import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/presentation/screens/create_team_screen.dart';
import 'package:sportifind/features/team/presentation/widgets/my_teams_list_view.dart';
import 'package:sportifind/features/team/presentation/widgets/nearby_team_list_view.dart';
import 'package:sportifind/features/team/presentation/widgets/search_bar.dart';

class TeamMainScreen extends StatefulWidget {
  const TeamMainScreen({super.key});

  @override
  State<TeamMainScreen> createState() => _TeamMainScreenState();
}

class _TeamMainScreenState extends State<TeamMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SportifindSearchBar(),
                    getMyTeamListview(),
                    getNearbyTeamListView(),
                  ],
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
          padding: const EdgeInsets.only(top: 8.0, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your teams',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: SportifindTheme.darkGrey,
                ),
              ),
              const SizedBox(width: 100),
              SizedBox(
                height: 34, 
                width: 143,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SportifindTheme.bluePurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    fixedSize: const Size(143, 34),
                    elevation: 0,
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        size: 14,
                        Icons.add_circle_outline,
                        color: Colors.white,
                      ),
                       SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Create Team',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.27,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateTeamScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 0),
          child: MyTeamsListView(),
        ),
      ],
    );
  }

  Widget getNearbyTeamListView() {
    return const Padding(
      padding: EdgeInsets.only(top: 0, left: 16, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Nearby Teams',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: SportifindTheme.darkGrey,
            ),
          ),
          SizedBox(height: 0),
          NearbyTeamListView(),
        ],
      ),
    );
  }
}
