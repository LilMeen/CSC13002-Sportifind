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

   List<TeamEntity> sortTeamByLocation(
      List<TeamEntity> teams, Location location) {
    // sort by district and city
    String city = location.city;
    String district = location.district;

    List<TeamEntity> sortedTeamsByCity =
        teams.where((team) => team.location.city == city).toList();

    List<TeamEntity> sortedTeamsByDistrictUpper = sortedTeamsByCity
        .where((team) => team.location.district == district)
        .toList();
    List<TeamEntity> sortedTeamByDistrictLower = sortedTeamsByCity
        .where((team) => team.location.district != district)
        .toList();

    // concatenate the two lists
    sortedTeamsByDistrictUpper.addAll(sortedTeamByDistrictLower);
    return sortedTeamsByDistrictUpper;
  }

  Future<int> getUserAge(String dob) async {
    final dobSplit = dob.split('/');
    final dobYear = int.parse(dobSplit[2]);
    final now = DateTime.now();
    final nowYear = now.year;
    return nowYear - dobYear;
  }

