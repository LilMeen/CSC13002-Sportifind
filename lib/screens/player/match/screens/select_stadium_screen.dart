import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/date_select_screen.dart';
import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/match/util/pop_result.dart';
import 'package:sportifind/screens/player/match/widgets/common_button.dart';
import 'package:sportifind/screens/player/stadium/player_stadium_screen.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';

class SelectStadiumScreen extends StatefulWidget {
  const SelectStadiumScreen({
    super.key,
    required this.addMatchCard,
  });

  final void Function(MatchCard matchcard) addMatchCard;

  @override
  State<StatefulWidget> createState() => _SelectStadiumScreenState();
}

class _SelectStadiumScreenState extends State<SelectStadiumScreen> {
  String? _selectedTeam;
  String? _selectedStadiumName;
  String? _selectedStadiumId;
  int? _numberOfField;
  final user = FirebaseAuth.instance.currentUser!;

  late Future<List<String>> _teamFuture;

  final List<String> team = [];

  var avatar = ['lib/assets/logo/real_madrid.png', 'lib/assets/logo/logo.png'];

  @override
  void initState() {
    super.initState();
    _teamFuture = getTeamData();
  }

  Future<List<String>> getTeamData() async {
    final teamQuery =
        await FirebaseFirestore.instance.collection('teams').get();
    final teams = teamQuery.docs
        .map((match) => TeamInformation.fromSnapshot(match))
        .toList();

    for (var i = 0; i < teams.length; ++i) {
      if (teams[i].captain == user.uid) {
        team.add(teams[i].name);
      }
    }
    print(team);
    return team;
  }

  Widget dropDownBox(String title, String hintText, double height,
      List<String> list, String? selectedValue, String avatar) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SportifindTheme.display2,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: SportifindTheme.nearlyGreen,
            ),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(5.0),
              hint: Text(
                hintText,
                style: SportifindTheme.title,
              ),
              value: selectedValue,
              isExpanded: true,
              items: list.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Row(
                    children: [
                      Image.asset(avatar, width: 25),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(items),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  if (title == 'Team') {
                    _selectedTeam = value;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget stadiumPicker(String title, String hintText, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SportifindTheme.display2,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: SportifindTheme.nearlyGreen,
          ),
          child: TextButton(
            onPressed: () async {
              final result = await Navigator.push<PopWithResults>(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "Select_stadium"),
                  builder: (context) => const PlayerStadiumScreen(
                    forMatchCreate: true,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  _selectedStadiumId = result.results![0];
                  _selectedStadiumName = result.results![1];
                  _numberOfField = int.parse(result.results![2]);
                });
              }
            },
            child: _selectedStadiumName == null
                ? Text(
                    hintText,
                    style: SportifindTheme.title,
                  )
                : Text(
                    _selectedStadiumName!,
                    style: SportifindTheme.title,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SportifindTheme.background,
            leading: BackButton(
              color: SportifindTheme.nearlyGreen,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MatchMainScreen()),
                );
              },
            ),
            centerTitle: true,
            title: const Text(
              "Create match",
              style: SportifindTheme.display1,
            ),
          ),
          backgroundColor: SportifindTheme.background,
          body: Padding(
            padding: const EdgeInsets.only(
                left: 50.0, right: 50.0, bottom: 130, top: 50),
            child: FutureBuilder<List<String>>(
              future: _teamFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading teams'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dropDownBox("Team", "Choose your team", 40,
                          snapshot.data!, _selectedTeam, avatar[0]),
                      const SizedBox(height: 40),
                      stadiumPicker("Stadium", "Choose your stadium", 40),
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CommonButton(
                            text: 'Next',
                            width: 100,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DateSelectScreen(
                                    selectedTeam: _selectedTeam!,
                                    selectedStadiumId: _selectedStadiumId!,
                                    selectedStadiumName: _selectedStadiumName!,
                                    numberOfField: _numberOfField!,
                                    addMatchCard: widget.addMatchCard,
                                  ),
                                ),
                              );
                            },
                            isDisabled: (_selectedTeam == null),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
