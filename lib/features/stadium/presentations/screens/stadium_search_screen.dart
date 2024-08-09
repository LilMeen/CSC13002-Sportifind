import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/entities/stadium_owner.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';
import 'package:sportifind/features/auth/presentations/widgets/cards/match_card.dart';
import 'package:sportifind/features/auth/presentations/widgets/cards/stadium_card.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium.dart';
import 'package:sportifind/features/stadium/domain/usecases/search_stadium.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_nearby_stadium.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_map_search_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/create_stadium_screen.dart';
import 'package:sportifind/features/stadium/presentations/widgets/current_location_button.dart';
import 'package:sportifind/features/stadium/presentations/widgets/custom_search_bar.dart';

class StadiumSearchScreen extends StatefulWidget {
  final int gridCol;
  final double gridRatio;
  final double imageRatio;
  final Location userLocation;
  final List<Stadium> stadiums;
  final List<StadiumOwner> owners;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final String? selectedTeamAvatar;
  final void Function(MatchCard matchcard)? addMatchCard;


  const StadiumSearchScreen({
    super.key,
    required this.gridCol,
    required this.gridRatio,
    required this.imageRatio,
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
  List<Stadium> searchedStadiums = [];
  String searchText = '';
  String textResult = '-Nearby stadiums-';
  late Map<String, String> ownerMap;
  final Map<String, String> citiesNameAndId = {};
  String selectedCity = '';
  String selectedDistrict = '';
  late Location currentLocation;
  bool isLoadingLocation = false;
  double floatingDistance = 0.0;

  @override 
  void initState() async {
    super.initState();
    searchController.addListener(onSearchChanged);
    searchText = searchController.text;

    searchedStadiums = widget.stadiums;
    currentLocation = widget.userLocation;
    searchedStadiums = await UseCaseProvider.getUseCase<GetNearbyStadium>().call(
      GetNearbyStadiumParams(
        searchedStadiums,
        currentLocation,
      ),
    ).then((value) => value.data!);

    ownerMap = {for (var owner in widget.owners) owner.id: owner.name};
    if (widget.isStadiumOwnerUser) {
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
    setState(() async {
      searchedStadiums = await UseCaseProvider.getUseCase<SearchStadium>().call(
        SearchStadiumParams(
          widget.stadiums,
          searchText,
          selectedCity,
          selectedDistrict,
        ),
      ).then((value) => value.data!);
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
      Location? location = await getCurrentLocation();
      setState(() async {
        currentLocation = location!;
        searchedStadiums = await UseCaseProvider.getUseCase<GetNearbyStadium>().call(
          GetNearbyStadiumParams(
            searchedStadiums,
            currentLocation,
          ),
        ).then((value) => value.data!);
        textResult = '-Nearby stadiums-';
      });
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
                            isStadiumOwnerUser: widget.isStadiumOwnerUser,
                            forMatchCreate: widget.forMatchCreate,
                            selectedTeamId: widget.selectedTeamId,
                            selectedTeamName: widget.selectedTeamName,
                            selectedTeamAvatar: widget.selectedTeamAvatar,
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
          widget.isStadiumOwnerUser
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: FloatingActionButton(
                      heroTag: "createStadium",
                      onPressed: () {
                        Navigator.of(context).push(CreateStadiumScreen.route());
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
                        isStadiumOwnerUser: widget.isStadiumOwnerUser,
                        forMatchCreate: widget.forMatchCreate,
                        selectedTeamId: widget.selectedTeamId,
                        selectedTeamName: widget.selectedTeamName,
                        selectedTeamAvatar: widget.selectedTeamAvatar,
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
