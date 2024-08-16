import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_card.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/bloc/stadium_search_bloc.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_map_search_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/create_stadium_screen.dart';
import 'package:sportifind/features/stadium/presentations/widgets/current_location_button.dart';
import 'package:sportifind/features/stadium/presentations/widgets/custom_search_bar.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

const double floatingDistance = 65.0;

class StadiumSearchScreen extends StatefulWidget {
  final Location userLocation;
  final List<StadiumEntity> stadiums;
  final List<StadiumOwnerEntity> owners;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final TeamEntity? selectedTeam;


  const StadiumSearchScreen({
    super.key,
    required this.userLocation,
    required this.stadiums,
    required this.owners,
    this.isStadiumOwnerUser = false,
    this.forMatchCreate = false,
    this.selectedTeam,
  });

  @override
  State<StadiumSearchScreen> createState() => StadiumSearchScreenState();
}

class StadiumSearchScreenState extends State<StadiumSearchScreen> {
  late StadiumSearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = StadiumSearchBloc(context, widget.userLocation, widget.stadiums, widget.owners);
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: StreamBuilder<StadiumSearchState>(
        stream: _bloc.stateStream,
        initialData: _bloc.currentState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final state = snapshot.data!;

          if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          }

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
                        searchController: _bloc.searchController,
                        hintText: 'Stadium name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CityDropdown(
                              selectedCity: state.selectedCity,
                              citiesNameAndId: _bloc.citiesNameAndId,
                              onChanged: _bloc.onCityChanged,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DistrictDropdown(
                              selectedCity: state.selectedCity,
                              selectedDistrict: state.selectedDistrict,
                              citiesNameAndId: _bloc.citiesNameAndId,
                              onChanged: _bloc.onDistrictChanged,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          CurrentLocationButton(
                            width: 56,
                            height: 56,
                            isLoading: state.isLoadingLocation,
                            onPressed: _bloc.getCurrentLocationAndSort,
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
                          state.textResult,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: state.searchedStadiums.isEmpty
                          ? const Center(child: Text('No stadiums found.'))
                          : GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: state.searchedStadiums.length,
                              itemBuilder: (ctx, index) {
                                final stadium = state.searchedStadiums[index];
                                final ownerName =
                                    state.ownerMap[stadium.ownerId] ?? '';

                                return StadiumCard(
                                  stadium: stadium,
                                  ownerName: ownerName,
                                  imageRatio: 2.475,
                                  isStadiumOwnerUser: widget.isStadiumOwnerUser,
                                  forMatchCreate: widget.forMatchCreate,
                                  selectedTeam: widget.selectedTeam,
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
                    padding: EdgeInsets.only(bottom: 70 + floatingDistance * (widget.isStadiumOwnerUser ? 1 : 0)),
                    child: FloatingActionButton(
                      heroTag: "stadiumMapSearch",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StadiumMapSearchScreen(
                              userLocation: state.currentLocation,
                              stadiums: state.searchedStadiums,
                              owners: widget.owners,
                              isStadiumOwnerUser: widget.isStadiumOwnerUser,
                              forMatchCreate: widget.forMatchCreate,
                              selectedTeam: widget.selectedTeam!,
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
            
        },  
      )
    );
  }
}
