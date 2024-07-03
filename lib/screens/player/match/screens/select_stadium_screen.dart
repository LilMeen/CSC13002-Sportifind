import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/date_select_screen.dart';
import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/match/widgets/common_button.dart';

class SelectStadiumScreen extends StatefulWidget {
  const SelectStadiumScreen({super.key, required this.addMatchCard});

  final void Function(MatchCard matchcard) addMatchCard;

  @override
  State<StatefulWidget> createState() => _SelectStadiumScreenState();
}

class _SelectStadiumScreenState extends State<SelectStadiumScreen> {
  String? _selectedTeam;
  String? _selectedStadium;

  var avatar = ['lib/assets/logo/real_madrid.png', 'lib/assets/logo/logo.png'];

  var teams = [
    'Team 1',
    'Team 2',
    'Team 3',
    'Team 4',
    'Team 5',
    'Team 6',
  ];

  var stadiums = [
    'Phú Thọ stadium',
    'Mỹ Đình stadium',
  ]; 

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
                  } else if (title == 'Stadium') {
                    _selectedStadium = value;
                  }
                });
              },
            ),
          ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dropDownBox("Team", "Choose your team", 40, teams,
                    _selectedTeam, avatar[0]),
                const SizedBox(height: 40),
                dropDownBox("Stadium", "Choose stadium", 40, stadiums,
                    _selectedStadium, avatar[1]),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CommonButton(
                      text: 'Next',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DateSelectScreen(
                              selectedTeam: _selectedTeam!,
                              selectedStadium: _selectedStadium!,
                              addMatchCard: widget.addMatchCard,
                            ),
                          ),
                        );
                      },
                      isDisabled:
                          (_selectedStadium == null || _selectedTeam == null),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
