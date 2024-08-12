import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/user_service.dart';

class StatisticService {
  StadiumService stadiumService = StadiumService();
  MatchService matchService = MatchService();
  UserService userService = UserService();
  DateFormat dateFormat = DateFormat("mm/dd/yyyy");

  void getWeeklyRevenue(DateTimeRange week) async {
    List<MatchCard> totalMatch = [];
    List<MatchCard> filteredMatch = [];
    double revenue = 0;

    final List<StadiumData> ownerStadium =
        await stadiumService.getOwnerStadiumsData();
    for (var i = 0; i < ownerStadium.length; ++i) {
      final List<MatchCard> matchData =
          await matchService.getMatchDataByStadiumId(ownerStadium[i].id);
      totalMatch.addAll(matchData);
    }

    for (var i = 0; i < totalMatch.length; ++i) {
      DateTime matchDate = dateFormat.parse(totalMatch[i].date);
      if (matchDate.isBefore(week.end) && matchDate.isAfter(week.start)) {
        filteredMatch.add(totalMatch[i]);
      }
    }

    for (var i = 0; i < filteredMatch.length; ++i) {
      for (var j = 0; j < ownerStadium.length; ++j) {
        if (ownerStadium[j].id == filteredMatch[i].stadium &&
            ownerStadium[j]
                .fields
                .any((element) => element == filteredMatch[i].field)) {}
      }
    }
  }
}
