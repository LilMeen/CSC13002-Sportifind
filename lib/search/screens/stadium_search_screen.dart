import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/search/widgets/stadium_map_button.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/create_stadium_screen.dart';
import 'package:sportifind/search/widgets/custom_search_bar.dart';
import 'package:sportifind/search/screens/stadium_map_search.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';
import 'package:sportifind/widgets/location_button/current_location_icon_button.dart';

class StadiumSearchScreen extends StatefulWidget {
  final LocationInfo userLocation;
  final List<StadiumData> stadiums;
  final List<OwnerData> owners;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
  final void Function(MatchCard matchCard)? addMatchCard;

  const StadiumSearchScreen({
    super.key,
    required this.userLocation,
    required this.stadiums,
    required this.owners,
    this.isStadiumOwnerUser = false,
    this.forMatchCreate = false,
    this.addMatchCard,
    this.selectedTeamId,
    this.selectedTeamName,
    this.selectedTeamAvatar,
  });

  @override
  State<StadiumSearchScreen> createState() => StadiumSearchScreenState();
}

class StadiumSearchScreenState extends State<StadiumSearchScreen> {
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();
  List<StadiumData> searchedStadiums = [];
  String searchText = '';
  String textResult = 'Nearby stadiums';
  late Map<String, String> ownerMap;
  final Map<String, String> citiesNameAndId = {};
  String selectedCity = '';
  String selectedDistrict = '';
  late LocationInfo currentLocation;
  bool isLoadingLocation = false;
  StadiumService stadService = StadiumService();
  LocationService locService = LocationService();

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    searchText = searchController.text;

    searchedStadiums = widget.stadiums;
    currentLocation = widget.userLocation;
    searchedStadiums =
        stadService.sortNearbyStadiums(searchedStadiums, currentLocation);

    ownerMap = {for (var owner in widget.owners) owner.id: owner.name};
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
      searchedStadiums = stadService.performStadiumSearch(
        widget.stadiums,
        searchText,
        selectedCity,
        selectedDistrict,
      );
      textResult = 'Searching results';
      if (searchText.isEmpty &&
          selectedCity.isEmpty &&
          selectedDistrict.isEmpty) {
        searchedStadiums =
            stadService.sortNearbyStadiums(widget.stadiums, currentLocation);
        textResult = 'Nearby stadiums';
      }
    });
  }

  Future<void> getCurrentLocationAndSort() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      LocationInfo? location = await locService.getCurrentLocation();
      if (location != null) {
        setState(() {
          currentLocation = location;
          searchedStadiums =
              stadService.sortNearbyStadiums(searchedStadiums, currentLocation);
          textResult = 'Nearby stadiums';
        });
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  List<Widget> buildStadiumCards() {
    return searchedStadiums.map((stadium) {
      final ownerName = ownerMap[stadium.owner] ?? 'Unknown';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: StadiumCard(
          stadium: stadium,
          ownerName: ownerName,
          imageRatio: 2.475,
          isStadiumOwnerUser: widget.isStadiumOwnerUser,
          forMatchCreate: widget.forMatchCreate,
          selectedTeamId: widget.selectedTeamId,
          selectedTeamName: widget.selectedTeamName,
          selectedTeamAvatar: widget.selectedTeamAvatar,
          addMatchCard: widget.addMatchCard,
        ),
      );
    }).toList();
  }

  Widget buildStadiumSection() {
    return searchedStadiums.isEmpty
        ? Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(child: Text('No stadiums found.', style: SportifindTheme.normalTextSmokeScreen)),
        )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildStadiumCards(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SportifindTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSearchBar(
                        searchController: searchController,
                        hintText: 'Stadium name',
                      ),
                      const SizedBox(height: 20.0),
                      Row(
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
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: StadiumMapButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StadiumMapSearchScreen(
                                      userLocation: currentLocation,
                                      stadiums: searchedStadiums,
                                      owners: widget.owners,
                                      isStadiumOwnerUser:
                                          widget.isStadiumOwnerUser,
                                      forMatchCreate: widget.forMatchCreate,
                                      selectedTeamId: widget.selectedTeamId,
                                      selectedTeamName: widget.selectedTeamName,
                                      selectedTeamAvatar:
                                          widget.selectedTeamAvatar,
                                      addMatchCard: widget.addMatchCard,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          CurrentLocationIconButton(
                            isLoading: isLoadingLocation,
                            onPressed: getCurrentLocationAndSort,
                            size: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        textResult,
                        style: SportifindTheme.normalTextBlack,
                      ),
                      const SizedBox(height: 2.0),
                    ],
                  ),
                ),
                buildStadiumSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isStadiumOwnerUser
          ? FloatingActionButton(
              heroTag: "createStadium",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateStadiumScreen(),
                  ),
                );
              },
              backgroundColor: SportifindTheme.bluePurple,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
