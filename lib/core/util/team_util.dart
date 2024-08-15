import 'package:sportifind/core/entities/location.dart';
import 'package:sportifind/core/util/location_util.dart';
import 'package:sportifind/core/util/search_util.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';

  List<TeamEntity> sortNearbyTeams(List<TeamEntity> teams, Location markedLocation) {
    sortByDistance<TeamEntity>(
      teams,
      markedLocation,
      (teams) => teams.location,
    );
    return teams;
  }

  List<TeamEntity> performTeamSearch(List<TeamEntity> teams, String searchText, String selectedCity, String selectedDistrict) {
    return searchingNameAndLocation(
      listItems: teams,
      searchText: searchText,
      selectedCity: selectedCity,
      selectedDistrict: selectedDistrict,
      getNameOfItem: (teams) => teams.name,
      getLocationOfItem: (teams) => teams.location,
    );
  }

