// import 'package:flutter/material.dart';
// import 'package:sportifind/models/match_card.dart';
// import 'package:sportifind/screens/player/team/models/team_information.dart';
// import 'package:sportifind/widgets/team_list/team_cards.dart';

// class InviteTeamScreen extends StatefulWidget {
//   const InviteTeamScreen({super.key, required this.matchInfo});

//   final MatchCard matchInfo;

//   @override
//   State<StatefulWidget> createState() => _InviteTeamScreenState();
// }

// class _InviteTeamScreenState extends State<InviteTeamScreen> {
//   List<TeamInformation> team = [];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         children: [
//           TeamCards(
//             otherTeam: team,
//             hostId: widget.matchInfo.team1,
//             matchId: widget.matchInfo.id,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/player_data.dart';
import 'package:sportifind/screens/player/team/models/team_information.dart';
import 'package:sportifind/screens/player/team/screens/team_main_screen.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/create_stadium_screen.dart';
import 'package:sportifind/search/widgets/custom_search_bar.dart';
import 'package:sportifind/search/screens/stadium_map_search.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/team_service.dart';
import 'package:sportifind/util/user_service.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';
import 'package:sportifind/widgets/location_button/current_location_button.dart';
import 'package:sportifind/widgets/team_list/team_cards.dart';

class InviteTeamScreen extends StatefulWidget {
  const InviteTeamScreen({
    super.key,
    required this.matchInfo,
    required this.userLocation,
    required this.teams,
  });

  final MatchCard matchInfo;
  final LocationInfo userLocation;
  final List<TeamInformation> teams;

  @override
  State<InviteTeamScreen> createState() => _InviteTeamScreenState();
}

class _InviteTeamScreenState extends State<InviteTeamScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();
  List<TeamInformation> searchedTeam = [];
  String searchText = '';
  String textResult = '-Nearby teams-';
  late Map<String, String> ownerMap;
  final Map<String, String> citiesNameAndId = {};
  String selectedCity = '';
  String selectedDistrict = '';
  late LocationInfo currentLocation;
  bool isLoadingLocation = false;

  TeamService teamService = TeamService();

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    searchText = searchController.text;

    searchedTeam = widget.teams;
    print(searchedTeam);
    currentLocation = widget.userLocation;
    searchedTeam = teamService.sortNearbyTeams(searchedTeam, currentLocation);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchText = searchController.text;
        performSearch();
      });
    });
  }

  void performSearch() {
    setState(() {
      searchedTeam = teamService.performTeamSearch(
        widget.teams,
        searchText,
        selectedCity,
        selectedDistrict,
      );
      textResult = '-Searching results-';
      if (searchText.isEmpty &&
          selectedCity.isEmpty &&
          selectedDistrict.isEmpty) {
        textResult = '-Nearby teams-';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(
                  searchController: searchController,
                  hintText: 'Stadium name',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CityDropdown(
                        selectedCity: selectedCity,
                        citiesNameAndId: citiesNameAndId,
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value ?? '';
                            selectedDistrict = '';
                            performSearch();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: DistrictDropdown(
                        selectedCity: selectedCity,
                        citiesNameAndId: citiesNameAndId,
                        selectedDistrict: selectedDistrict,
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value ?? '';
                            performSearch();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    textResult,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TeamCards(
                  otherTeam: searchedTeam,
                  hostId: widget.matchInfo.team1,
                  matchId: widget.matchInfo.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
