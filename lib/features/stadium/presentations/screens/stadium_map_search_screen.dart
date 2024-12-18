import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/features/stadium/presentations/widgets/stadium_card.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/presentations/bloc/stadium_map_search_bloc.dart';
import 'package:sportifind/features/stadium/presentations/widgets/current_location_icon_button.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

class StadiumMapSearchScreen extends StatefulWidget {
  final Location userLocation;
  final List<StadiumEntity> stadiums;
  final List<StadiumOwnerEntity> owners;
  final bool isStadiumOwnerUser;
  final bool forMatchCreate;
  final TeamEntity? selectedTeam;
  final void Function(MatchEntity matchcard)? addMatchCard;

  const StadiumMapSearchScreen({
    super.key,
    required this.userLocation,
    required this.stadiums,
    required this.owners,
    required this.isStadiumOwnerUser,
    required this.forMatchCreate,
    this.addMatchCard,
    this.selectedTeam,
  });

  @override
  State<StadiumMapSearchScreen> createState() => _StadiumMapSearchScreenState();
}

class _StadiumMapSearchScreenState extends State<StadiumMapSearchScreen> {
  late StadiumMapSearchBloc _bloc;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = StadiumMapSearchBloc(
        context, widget.userLocation, widget.stadiums, widget.owners);
  }

  @override
  void dispose() {
    _bloc.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<StadiumMapSearchState>(
        stream: _bloc.stateStream,
        initialData: _bloc.currentState,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _bloc.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.userLocation.latitude,
                      widget.userLocation.longitude),
                  zoom: 11.0,
                ),
                markers: state.markers,
                zoomControlsEnabled: false,
                compassEnabled: false,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8.0,
                left: 8.0,
                right: 8.0,
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: SportifindTheme.bluePurple),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: TextField(
                      controller: searchController,
                      style: SportifindTheme.normalText,
                      decoration: InputDecoration(
                        hintText: 'Search for a place, location',
                        hintStyle: SportifindTheme.normalText
                            .copyWith(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _bloc.searchLocation,
                    ),
                    trailing: CurrentLocationIconButton(
                      isLoading: state.isLoadingLocation,
                      onPressed: _bloc.getCurrentLocationAndSortOnMap,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 265,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.nearbyStadiums.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2);
                      } else {
                        final stadium = state.nearbyStadiums[index - 1];
                        final ownerName = state.ownerMap[stadium.ownerId] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: SizedBox(
                            width: 195,
                            child: StadiumCard(
                              stadium: stadium,
                              ownerName: ownerName,
                              imageRatio: 1.15,
                              isStadiumOwnerUser: widget.isStadiumOwnerUser,
                              forMatchCreate: widget.forMatchCreate,
                              selectedTeam: widget.selectedTeam,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
