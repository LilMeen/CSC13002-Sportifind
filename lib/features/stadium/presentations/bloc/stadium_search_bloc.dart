import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/features/profile/domain/entities/stadium_owner_entity.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/search_stadium.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_nearby_stadium.dart';

class StadiumSearchState {
  final bool isLoadingLocation;
  final String errorMessage;

  final List<StadiumEntity> searchedStadiums;
  final Map<String, String> ownerMap;
  final String searchText;
  final String selectedCity;
  final String selectedDistrict;
  final Location currentLocation;
  final String textResult;

  StadiumSearchState({
    this.isLoadingLocation = false,
    this.errorMessage = '',

    this.searchedStadiums = const [],
    this.ownerMap = const {},
    this.searchText = '',
    this.selectedCity = '',
    this.selectedDistrict = '',
    this.currentLocation = const Location(),
    this.textResult = '-Nearby stadiums-',
  });

  StadiumSearchState copyWith({
    bool? isLoadingLocation,
    String? errorMessage,

    List<StadiumEntity>? searchedStadiums,
    Map<String, String>? ownerMap,
    String? searchText,
    String? selectedCity,
    String? selectedDistrict,
    Map<String, String>? citiesNameAndId,
    Location? currentLocation,
    String? textResult,
  }) {
    return StadiumSearchState(
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      errorMessage: errorMessage ?? this.errorMessage,

      searchedStadiums: searchedStadiums ?? this.searchedStadiums,
      ownerMap: ownerMap ?? this.ownerMap,
      searchText: searchText ?? this.searchText,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      currentLocation: currentLocation ?? this.currentLocation,
      textResult: textResult ?? this.textResult,
    );
  }
}

class StadiumSearchBloc {
  final Location userLocation;
  final List<StadiumEntity> stadiums;
  final List<StadiumOwnerEntity> owners;

  final BuildContext context;
  final _stateController = StreamController<StadiumSearchState>.broadcast();
  late StadiumSearchState _state;
  Timer? _debounce;

  Stream<StadiumSearchState> get stateStream => _stateController.stream;
  StadiumSearchState get currentState => _state;

  final TextEditingController searchController = TextEditingController();
  final Map<String, String> citiesNameAndId = {};

  StadiumSearchBloc(this.context, this.userLocation, this.stadiums, this.owners) : _state = StadiumSearchState() {
    _stateController.add(_state);
  }

  void init() {
    searchController.addListener(onSearchTextChanged);
    final searchText = searchController.text;
    final ownerMap = {for (var owner in owners) owner.id: owner.name};
    final searchedStadiums = NonFutureUseCaseProvider.getUseCase<GetNearbyStadium>().call(
      GetNearbyStadiumParams(
        stadiums,
        userLocation,
      ),
    ).data!;
    _state = StadiumSearchState(
      currentLocation: userLocation,
      searchedStadiums: searchedStadiums,
      ownerMap: ownerMap,
      searchText: searchText,
    );
  }

  void dispose() {
    searchController.removeListener(onSearchTextChanged);
    searchController.dispose();
    _stateController.close();
    _debounce?.cancel();
  }

  void _updateState(StadiumSearchState Function(StadiumSearchState) update) {
    _state = update(_state);
    _stateController.add(_state);
  }

  void onSearchTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateState((state) => state.copyWith(
        searchText: searchController.text,
        textResult: '-Searching results-',
      ));
      _performSearch();
    });
  }

  void onCityChanged(String? city) {
    _updateState((state) => state.copyWith(
      selectedCity: city ?? '',
      selectedDistrict: '',
    ));
    _performSearch();
  }

  void onDistrictChanged(String? district) {
    _updateState((state) => state.copyWith(selectedDistrict: district ?? ''));
    _performSearch();
  }

  Future<void> getCurrentLocationAndSort() async {
    _updateState((state) => state.copyWith(isLoadingLocation: true));

    try {
      Location? location = await getCurrentLocation();
      if (location != null) {
        _updateState((state) => state.copyWith(
          currentLocation: location,
          textResult: '-Nearby stadiums-',
        ));
        _performSearch();
      } else {
        throw Exception('Failed to get current location');
      }
    } catch (error) {
      _updateState((state) => state.copyWith(errorMessage: error.toString()));
    } finally {
      _updateState((state) => state.copyWith(isLoadingLocation: false));
    }
  }

  void _performSearch() {
    final searchedStadiums = NonFutureUseCaseProvider.getUseCase<SearchStadium>().call(
      SearchStadiumParams(
        stadiums,
        _state.searchText,
        _state.selectedCity,
        _state.selectedDistrict,
      ),
    ).data!;

    final sortedStadiums = NonFutureUseCaseProvider.getUseCase<GetNearbyStadium>().call(
      GetNearbyStadiumParams(
        searchedStadiums,
        _state.currentLocation,
      ),
    ).data!;

    _updateState((state) => state.copyWith(
      searchedStadiums: sortedStadiums,
      textResult: state.searchText.isEmpty && state.selectedCity.isEmpty && state.selectedDistrict.isEmpty
          ? '-Nearby stadiums-'
          : '-Searching results-',
    ));
  }
}