import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/services/location_service.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/stadium_owner/stadium/create_stadium_screen.dart';
import 'package:sportifind/search/widgets/custom_search_bar.dart';
import 'package:sportifind/search/screens/stadium_map_search.dart';
import 'package:sportifind/services/stadium_service.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/widgets/dropdown_button/city_dropdown.dart';
import 'package:sportifind/widgets/dropdown_button/district_dropdown.dart';
import 'package:sportifind/widgets/location_button/current_location_button.dart';

class StadiumSearchScreen extends StatefulWidget {
  final int gridCol;
  final double gridRatio;
  final double imageRatio;
  final LocationInfo userLocation;
  final List<StadiumData> stadiums;
  final List<OwnerData> owners;
  final bool forMatchCreate;
  final bool forStadiumCreate;
  final String? selectedTeam;
  final void Function(MatchCard matchcard)? addMatchCard;


  const StadiumSearchScreen({
    super.key,
    required this.gridCol,
    required this.gridRatio,
    required this.imageRatio,
    required this.userLocation,
    required this.stadiums,
    required this.owners,
    this.forMatchCreate = false,
    this.forStadiumCreate = false,
    this.addMatchCard,
    this.selectedTeam,
  });

  @override
  State<StadiumSearchScreen> createState() => StadiumSearchScreenState();
}

class StadiumSearchScreenState extends State<StadiumSearchScreen> {
  Timer? debounce;
  final TextEditingController searchController = TextEditingController();
  List<StadiumData> searchedStadiums = [];
  String searchText = '';
  String textResult = '-Nearby stadiums-';
  late Map<String, String> ownerMap;
  final Map<String, String> citiesNameAndId = {};
  String selectedCity = '';
  String selectedDistrict = '';
  late LocationInfo currentLocation;
  bool isLoadingLocation = false;
  double floatingDistance = 0.0;
  StadiumService stadService = StadiumService();
  LocationService locService = LocationService();

  @override 
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    searchText = searchController.text;

    searchedStadiums = widget.stadiums;
    currentLocation = widget.userLocation;
    searchedStadiums = stadService.sortNearbyStadiums(searchedStadiums, currentLocation);

    ownerMap = {for (var owner in widget.owners) owner.id: owner.name};
    if (widget.forStadiumCreate) {
      floatingDistance = 65.0;
    }
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
      textResult = '-Searching results-';
      if (searchText.isEmpty &&
          selectedCity.isEmpty &&
          selectedDistrict.isEmpty) {
        textResult = '-Nearby stadiums-';
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
          searchedStadiums = stadService.sortNearbyStadiums(searchedStadiums, currentLocation);
          textResult = '-Nearby stadiums-';
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
                    const SizedBox(width: 8.0),
                    CurrentLocationButton(
                      width: 56,
                      height: 56,
                      isLoading: isLoadingLocation,
                      onPressed: getCurrentLocationAndSort,
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
                child: searchedStadiums.isEmpty
                    ? const Center(child: Text('No stadiums found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.gridCol,
                          childAspectRatio: widget.gridRatio,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: searchedStadiums.length,
                        itemBuilder: (ctx, index) {
                          final stadium = searchedStadiums[index];
                          final ownerName =
                              ownerMap[stadium.owner] ?? 'Unknown';

                          return StadiumCard(
                            stadium: stadium,
                            ownerName: ownerName,
                            imageRatio: widget.imageRatio,
                            forMatchCreate: widget.forMatchCreate,
                            selectedTeam: widget.selectedTeam!,
                            addMatchCard: widget.addMatchCard,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          widget.forStadiumCreate
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: FloatingActionButton(
                      heroTag: "createStadium",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateStadiumScreen()),
                        );
                      },
                      backgroundColor: Colors.teal,
                      shape: const CircleBorder(),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                )
              : const SizedBox(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 70 + floatingDistance),
              child: FloatingActionButton(
                heroTag: "stadiumMapSearch",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StadiumMapSearchScreen(
                        userLocation: currentLocation,
                        stadiums: searchedStadiums,
                        owners: widget.owners,
                        forMatchCreate: widget.forMatchCreate,
                        selectedTeam: widget.selectedTeam,
                        addMatchCard: widget.addMatchCard,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.teal,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
