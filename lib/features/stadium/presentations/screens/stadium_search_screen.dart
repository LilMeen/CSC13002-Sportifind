import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/widgets/button/blue_purple_white_icon_normal_button.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/core/widgets/city_dropdown.dart';
import 'package:sportifind/core/widgets/district_dropdown.dart';
import 'package:sportifind/features/stadium/presentations/widgets/current_location_icon_button.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/bloc/stadium_search_bloc.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_map_search_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/create_stadium_screen.dart';
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
    _bloc = StadiumSearchBloc(
      context: context, 
      userLocation: widget.userLocation,
      stadiums: widget.stadiums,
      owners: widget.owners,
      isStadiumOwnerUser: widget.isStadiumOwnerUser,
      forMatchCreate: widget.forMatchCreate,
      selectedTeam: widget.selectedTeam,
    );
    _bloc.init();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSearchBar(
                              searchController: _bloc.searchController,
                              hintText: 'Stadium name',
                            ),
                            const SizedBox(height: 20.0),
                            Row(
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
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              children: [
                                Expanded(
                                  child: BluePurpleWhiteIconNormalButton(
                                    text: 'Open stadium map',
                                    icon: Icons.map_outlined,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                          StadiumMapSearchScreen(
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
                                  ),
                                ),
                                CurrentLocationIconButton(
                                  isLoading: state.isLoadingLocation,
                                  onPressed: _bloc.getCurrentLocationAndSort,
                                  size: 30,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              state.textResult,
                              style: SportifindTheme.normalTextBlack,
                            ),
                            const SizedBox(height: 2.0),
                          ],
                        ),
                      ),
                      _bloc.buildStadiumSection(),
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
        },
      ),
    );
  }
}
