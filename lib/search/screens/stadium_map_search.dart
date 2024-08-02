import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportifind/models/location_info.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/util/location_service.dart';
import 'package:sportifind/models/owner_data.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/widgets/card/stadium_card.dart';
import 'package:sportifind/widgets/location_button/current_location_icon_button.dart';

class StadiumMapSearchScreen extends StatefulWidget {
  final LocationInfo userLocation;
  final List<StadiumData> stadiums;
  final List<OwnerData> owners;
  final bool forMatchCreate;
  final String? selectedTeamId;
  final String? selectedTeamName;
  final void Function(MatchCard matchcard)? addMatchCard;

  const StadiumMapSearchScreen({
    super.key,
    required this.userLocation,
    required this.stadiums,
    required this.owners,
    required this.forMatchCreate,
    this.addMatchCard,
    this.selectedTeamId,
    this.selectedTeamName,
  });

  @override
  State<StadiumMapSearchScreen> createState() => _StadiumMapSearchScreenState();
}

class _StadiumMapSearchScreenState extends State<StadiumMapSearchScreen> {
  GoogleMapController? mapController;
  final TextEditingController searchController = TextEditingController();
  Marker? searchMarker;
  List<StadiumData> nearbyStadiums = [];
  late Map<String, String> ownerMap;
  bool isLoadingLocation = false;
  LocationInfo? searchLocation;
  LocationService locService = LocationService();
  StadiumService stadService = StadiumService();

  @override
  void initState() {
    super.initState();
    nearbyStadiums = widget.stadiums;
    ownerMap = {for (var owner in widget.owners) owner.id: owner.name};
    searchLocation = widget.userLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _getCurrentLocationAndSortOnMap() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      LocationInfo? location = await locService.getCurrentLocation();
      if (location != null) {
        setState(() {
          searchLocation = location;
          searchController.text = 'Current location';

          searchMarker = Marker(
            markerId: const MarkerId('userLocation'),
            position:
                LatLng(searchLocation!.latitude, searchLocation!.longitude),
            infoWindow: InfoWindow(
              title: 'Current location',
              snippet: searchLocation!.fullAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          );

          nearbyStadiums =  stadService.sortNearbyStadiums(nearbyStadiums, searchLocation!);
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(searchLocation!.latitude, searchLocation!.longitude),
              zoom: 14.0,
            ),
          ),
        );
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

  Future<void> _searchLocation(String searchText) async {
    if (searchText.isEmpty) return;

    if (searchText.toLowerCase() == 'current location') {
      await _getCurrentLocationAndSortOnMap();
      return;
    }

    for (var stadium in widget.stadiums) {
      if (searchText.toLowerCase() == stadium.name.toLowerCase()) {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(stadium.location.latitude, stadium.location.longitude),
              zoom: 14.0,
            ),
          ),
        );
        return;
      }
    }

    try {
      searchLocation = await locService.findLocation(searchText);

      if (searchLocation != null) {
        setState(() {
          searchMarker = Marker(
            markerId: const MarkerId('searchLocation'),
            position:
                LatLng(searchLocation!.latitude, searchLocation!.longitude),
            infoWindow: InfoWindow(
              title: searchLocation!.name,
              snippet: searchLocation!.fullAddress,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          );

          nearbyStadiums =  stadService.sortNearbyStadiums(nearbyStadiums, searchLocation!);
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(searchLocation!.latitude, searchLocation!.longitude),
              zoom: 14.0,
            ),
          ),
        );
      } else {
        throw Exception('Location not found');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = widget.stadiums.map((stadium) {
      return Marker(
        markerId: MarkerId(stadium.id),
        position: LatLng(stadium.location.latitude, stadium.location.longitude),
        infoWindow: InfoWindow(
          title: stadium.name,
          snippet:
              '${stadium.location.address}, ${stadium.location.district}, ${stadium.location.city}',
        ),
      );
    }).toSet();

    markers.add(
      Marker(
        markerId: const MarkerId('userLocation'),
        position:
            LatLng(widget.userLocation.latitude, widget.userLocation.longitude),
        infoWindow: widget.userLocation.address.isEmpty
            ? InfoWindow(
                title: 'Your location',
                snippet: widget.userLocation.fullAddress,
              )
            : InfoWindow(
                title: 'Your location',
                snippet:
                    '${widget.userLocation.district}, ${widget.userLocation.city}',
              ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

    if (searchMarker != null) {
      markers.add(searchMarker!);
    }

    return markers;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.userLocation.latitude, widget.userLocation.longitude),
              zoom: 11.0,
            ),
            markers: _createMarkers(),
            zoomControlsEnabled: false,
            compassEnabled: false,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.0,
            left: 8.0,
            right: 8.0,
            child: Card(
              child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for a place, location',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _searchLocation,
                  ),
                  trailing: CurrentLocationIconButton(
                    isLoading: isLoadingLocation,
                    onPressed: _getCurrentLocationAndSortOnMap,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.318,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.stadiums.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    );
                  } else {
                    final stadium = nearbyStadiums[index - 1];
                    final ownerName = ownerMap[stadium.owner] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: StadiumCard(
                          stadium: stadium,
                          ownerName: ownerName,
                          imageRatio: 1,
                          forMatchCreate: widget.forMatchCreate,
                          selectedTeamId: widget.selectedTeamId,
                          selectedTeamName: widget.selectedTeamName,
                          addMatchCard: widget.addMatchCard,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
