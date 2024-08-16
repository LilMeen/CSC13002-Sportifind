import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/util/team_util.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/stadium/presentations/widgets/custom_search_bar.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/features/team/presentation/widgets/team_cards.dart';


class InviteTeamScreen extends StatefulWidget {
  const InviteTeamScreen({
    super.key,
    required this.matchInfo,
    required this.userLocation,
    required this.teams,
  });

  final MatchEntity matchInfo;
  final Location userLocation;
  final List<TeamEntity> teams;

  @override
  State<InviteTeamScreen> createState() => _InviteTeamScreenState();
}

class _InviteTeamScreenState extends State<InviteTeamScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();
  List<TeamEntity> searchedTeam = [];
  String searchText = '';
  String textResult = 'Nearby teams';
  late Map<String, String> ownerMap;
  final Map<String, String> citiesNameAndId = {};
  String selectedCity = '';
  String selectedDistrict = '';
  late Location currentLocation;
  bool isLoadingLocation = false;


  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    searchText = searchController.text;

    searchedTeam = widget.teams;
    currentLocation = widget.userLocation;
    searchedTeam = sortNearbyTeams(searchedTeam, currentLocation);
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
      searchedTeam = performTeamSearch(
        widget.teams,
        searchText,
        selectedCity,
        selectedDistrict,
      );
      textResult = 'Searching results';
      if (searchText.isEmpty &&
          selectedCity.isEmpty &&
          selectedDistrict.isEmpty) {
        textResult = 'Nearby teams';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Invite match",
          style: SportifindTheme.sportifindAppBarForFeature,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                searchController: searchController,
                hintText: 'Stadium name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textResult,
                  style: SportifindTheme.normalTextBlack,
                ),
              ),
            ),
            Flexible(
              child: TeamCards(
                otherTeam: searchedTeam,
                hostId: widget.matchInfo.team1.id,
                matchId: widget.matchInfo.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
