import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_nearby_stadium.dart';

class StadiumMapSearchState {
  final bool isLoading;
  final bool isLoadingLocation;
  final String errorMessage;
  final List<StadiumEntity> nearbyStadiums;
  final Map<String, String> ownerMap;
  final Marker? searchMarker;
  final Location? searchLocation;
  final Set<Marker> markers;

  StadiumMapSearchState({
    this.isLoading = false,
    this.isLoadingLocation = false,
    this.errorMessage = '',
    this.nearbyStadiums = const [],
    this.ownerMap = const {},
    this.searchMarker,
    this.searchLocation,
    this.markers = const {},
  });

  StadiumMapSearchState copyWith({
    bool? isLoading,
    bool? isLoadingLocation,
    String? errorMessage,
    List<StadiumEntity>? nearbyStadiums,
    Map<String, String>? ownerMap,
    Marker? searchMarker,
    Location? searchLocation,
    Set<Marker>? markers,
  }) {
    return StadiumMapSearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      errorMessage: errorMessage ?? this.errorMessage,
      nearbyStadiums: nearbyStadiums ?? this.nearbyStadiums,
      ownerMap: ownerMap ?? this.ownerMap,
      searchMarker: searchMarker ?? this.searchMarker,
      searchLocation: searchLocation ?? this.searchLocation,
      markers: markers ?? this.markers,
    );
  }
}

class StadiumMapSearchBloc {
  final BuildContext context;
  final Location userLocation;
  final List<StadiumEntity> stadiums;
  final List<StadiumOwnerEntity> owners;

  final _stateController = StreamController<StadiumMapSearchState>.broadcast();
  late StadiumMapSearchState _state;
  GoogleMapController? mapController;

  Stream<StadiumMapSearchState> get stateStream => _stateController.stream;
  StadiumMapSearchState get currentState => _state;

  StadiumMapSearchBloc(
      this.context, this.userLocation, this.stadiums, this.owners)
      : _state = StadiumMapSearchState() {
    _initState();
  }

  void _initState() {
    final ownerMap = {for (var owner in owners) owner.id: owner.name};
    final markers = _createMarkers(null);
    _state = StadiumMapSearchState(
      nearbyStadiums: stadiums,
      ownerMap: ownerMap,
      searchLocation: userLocation,
      markers: markers,
    );
    _stateController.add(_state);
  }

  void dispose() {
    _stateController.close();
    mapController?.dispose();
  }

  void _updateState(
      StadiumMapSearchState Function(StadiumMapSearchState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocationAndSortOnMap() async {
    _updateState((state) => state.copyWith(isLoadingLocation: true));

    try {
      Location? location = await getCurrentLocation();
      if (location != null) {
        final searchMarker = Marker(
          markerId: const MarkerId('userLocation'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: 'Current location',
            snippet: location.fullAddress,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );

        final nearbyStadiums =
            NonFutureUseCaseProvider.getUseCase<GetNearbyStadium>()
                .call(
                  GetNearbyStadiumParams(stadiums, location),
                )
                .data!;

        _updateState((state) => state.copyWith(
              searchLocation: location,
              searchMarker: searchMarker,
              nearbyStadiums: nearbyStadiums,
              markers: _createMarkers(searchMarker),
            ));

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 14.0,
            ),
          ),
        );
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (error) {
      _updateState((state) => state.copyWith(errorMessage: error.toString()));
    } finally {
      _updateState((state) => state.copyWith(isLoadingLocation: false));
    }
  }

  Future<void> searchLocation(String searchText) async {
    if (searchText.isEmpty) return;

    if (searchText.toLowerCase() == 'current location') {
      await getCurrentLocationAndSortOnMap();
      return;
    }
    for (var stadium in stadiums) {
      if (searchText.toLowerCase() == stadium.name.toLowerCase()) {
        final nearbyStadiums =
            NonFutureUseCaseProvider.getUseCase<GetNearbyStadium>()
                .call(
                  GetNearbyStadiumParams(stadiums, stadium.location),
                )
                .data!;

        _updateState((state) => state.copyWith(
              searchLocation: null,
              searchMarker: null,
              nearbyStadiums: nearbyStadiums,
              markers: _createMarkers(null),
            ));

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
      final searchLocation = await findLocation(searchText);

      if (searchLocation != null) {
        final searchMarker = Marker(
          markerId: const MarkerId('searchLocation'),
          position: LatLng(searchLocation.latitude, searchLocation.longitude),
          infoWindow: InfoWindow(
            title: searchLocation.name,
            snippet: searchLocation.fullAddress,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        );

        final nearbyStadiums =
            NonFutureUseCaseProvider.getUseCase<GetNearbyStadium>()
                .call(
                  GetNearbyStadiumParams(stadiums, searchLocation),
                )
                .data!;

        _updateState((state) => state.copyWith(
              searchLocation: searchLocation,
              searchMarker: searchMarker,
              nearbyStadiums: nearbyStadiums,
              markers: _createMarkers(searchMarker),
            ));

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(searchLocation.latitude, searchLocation.longitude),
              zoom: 14.0,
            ),
          ),
        );
      } else {
        throw Exception('Location not found');
      }
    } catch (error) {
      _updateState((state) => state.copyWith(errorMessage: error.toString()));
    }
  }

  // PRIVATE METHODS
  Set<Marker> _createMarkers(Marker? searchMarker) {
    Set<Marker> markers = stadiums.map((stadium) {
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
        position: LatLng(userLocation.latitude, userLocation.longitude),
        infoWindow: userLocation.address.isEmpty
            ? InfoWindow(
                title: 'Your location', snippet: userLocation.fullAddress)
            : InfoWindow(
                title: 'Your location',
                snippet: '${userLocation.district}, ${userLocation.city}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );

    if (searchMarker != null) {
      markers.add(searchMarker);
    }

    return markers;
  }
}
