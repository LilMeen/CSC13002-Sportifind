import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/util/match_service.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/util/user_service.dart';

class StatisticService {
  StadiumService stadiumService = StadiumService();
  MatchService matchService = MatchService();
  UserService userService = UserService();
  late Map<String, double> fieldMap;
  List<double> stadiumRevenue = [];

  double timeStringToDouble(String timeStr) {
    // Split the string into hours and minutes
    List<String> parts = timeStr.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Convert minutes to a fraction of an hour and add to the hours
    double timeDouble = hours + minutes / 60.0;

    return timeDouble;
  }

  DateTime parseDateTime(String dateStr, String timeStr) {
    // Parse the date string into a DateTime object
    List<String> dateParts = dateStr.split('/');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Parse the time string into hours and minutes
    List<String> timeParts = timeStr.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Combine the date and time into a DateTime object
    DateTime dateTime = DateTime(year, month, day, hours, minutes);

    return dateTime;
  }

  Future<Map<String, List<MatchCard>>> getFilteredMatch(
      DateTimeRange week) async {
    Map<String, List<MatchCard>> matchOfEachStadium = {};
    List<MatchCard> filteredMatch = [];

    final List<StadiumData> ownerStadium =
        await stadiumService.getOwnerStadiumsData();
    for (var i = 0; i < ownerStadium.length; ++i) {
      final List<MatchCard> matchData =
          await matchService.getMatchDataByStadiumId(ownerStadium[i].id);
      for (var j = 0; j < matchData.length; ++j) {
        DateTime matchDate =
            parseDateTime(matchData[j].date, matchData[j].start);
        if (matchDate.isBefore(week.end) && matchDate.isAfter(week.start)) {
          filteredMatch.add(matchData[j]);
        }
      }
      matchOfEachStadium.addAll({ownerStadium[i].id: filteredMatch});
      filteredMatch = [];
    }

    return matchOfEachStadium;
  }

  Future<Map<String, double>> getRevenueOfEachStadium(
      Map<String, List<MatchCard>> matchMap) async {
    Map<String, double> result = {};

    // Get and preprocess owner stadium data
    final List<StadiumData> ownerStadiums =
        await stadiumService.getOwnerStadiumsData();

    // Create a map from stadium ID to its data
    Map<String, StadiumData> stadiumDataMap = {
      for (var stadium in ownerStadiums) stadium.id: stadium
    };

    // Create a map from stadium ID to field ID to price map
    Map<String, Map<String, double>> stadiumFieldPriceMap = {};

    for (var stadium in ownerStadiums) {
      stadiumFieldPriceMap[stadium.id] =
          await stadiumService.generateFieldPriceMap(stadium.id);
    }

    // Iterate over each stadium in matchMap
    for (var entry in matchMap.entries) {
      String stadiumKey = entry.key;
      List<MatchCard> matchCards = entry.value;

      double revenue = 0;

      // Skip if stadiumKey is not in stadiumDataMap
      if (!stadiumDataMap.containsKey(stadiumKey)) continue;

      StadiumData stadiumData = stadiumDataMap[stadiumKey]!;

      for (var matchCard in matchCards) {
        if (stadiumData.fields
            .any((element) => element.id == matchCard.field)) {
          // Use the preprocessed field price map
          Map<String, double> fieldMap = stadiumFieldPriceMap[stadiumKey]!;

          if (fieldMap.containsKey(matchCard.field)) {
            revenue += timeStringToDouble(matchCard.playTime) *
                fieldMap[matchCard.field]!;
          }
        }
      }

      // Store the result
      result[stadiumKey] = revenue;

      revenue = 0;
    }
    result = sortMap(result);
    return result;
  }

  Map<T, U> sortMap<T, U extends Comparable>(Map<T, U> map) {
    var sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => map[k1]!.compareTo(map[k2]!));

    LinkedHashMap<T, U> sortedMap = LinkedHashMap.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => map[k]!,
    );
    return sortedMap;
  }

  double getTotalRevenue(Map<String, double> stadiumRevenue) {
    double totalRevenue = 0;
    for (var entry in stadiumRevenue.entries) {
      double revenue = entry.value;
      totalRevenue += revenue;
    }
    return totalRevenue;
  }

  Future<Map<DateTime, int>> getMostDate(DateTimeRange week) async {
    List<MatchCard> filteredMatch = [];
    Map<DateTime, int> mostDateMap = {};

    final List<StadiumData> ownerStadium =
        await stadiumService.getOwnerStadiumsData();
    for (var i = 0; i < ownerStadium.length; ++i) {
      final List<MatchCard> matchData =
          await matchService.getMatchDataByStadiumId(ownerStadium[i].id);
      for (var j = 0; j < matchData.length; ++j) {
        DateTime matchDate =
            parseDateTime(matchData[j].date, matchData[j].start);
        if (matchDate.isBefore(week.end) && matchDate.isAfter(week.start)) {
          filteredMatch.add(matchData[j]);
        }
      }
    }

    for (DateTime date = week.start;
        date.isBefore(week.end) || date.isAtSameMomentAs(week.end);
        date = date.add(Duration(days: 1))) {
      int count = 0;
      for (var i = 0; i < filteredMatch.length; ++i) {
        if (date == parseDateTime(filteredMatch[i].date, "00:00")) {
          count += 1;
        }
      }
      mostDateMap.addAll({date: count});
    }
    mostDateMap = sortMap(mostDateMap);
    return mostDateMap;
  }

  Future<int> getTotalMatch(DateTimeRange week) async {
    List<MatchCard> filteredMatch = [];
    int count = 0;
    print(week);

    final List<StadiumData> ownerStadium =
        await stadiumService.getOwnerStadiumsData();
    for (var i = 0; i < ownerStadium.length; ++i) {
      final List<MatchCard> matchData =
          await matchService.getMatchDataByStadiumId(ownerStadium[i].id);
      for (var j = 0; j < matchData.length; ++j) {
        DateTime matchDate =
            parseDateTime(matchData[j].date, matchData[j].start);
        if (matchDate.isBefore(week.end) && matchDate.isAfter(week.start)) {
          filteredMatch.add(matchData[j]);
        }
      }
    }

    for (DateTime date = week.start;
        date.isBefore(week.end) || date.isAtSameMomentAs(week.end);
        date = date.add(Duration(days: 1))) {
      for (var i = 0; i < filteredMatch.length; ++i) {
        if (date == parseDateTime(filteredMatch[i].date, "00:00")) {
          count += 1;
        }
      }
    }
    return count;
  }

  Future<Map<String, int>> getMatchesEachStadium(
      Map<String, List<MatchCard>> matchMap) async {
    Map<String, int> result = {};

    // Get and preprocess owner stadium data
    final List<StadiumData> ownerStadiums =
        await stadiumService.getOwnerStadiumsData();

    // Create a map from stadium ID to its data
    Map<String, StadiumData> stadiumDataMap = {
      for (var stadium in ownerStadiums) stadium.id: stadium
    };

    // Create a map from stadium ID to field ID to price map
    print(matchMap);

    // Iterate over each stadium in matchMap
    for (var entry in matchMap.entries) {
      String stadiumKey = entry.key;
      List<MatchCard> matchCards = entry.value;

      int count = 0;

      // Skip if stadiumKey is not in stadiumDataMap
      if (!stadiumDataMap.containsKey(stadiumKey)) continue;

      StadiumData stadiumData = stadiumDataMap[stadiumKey]!;

      for (var matchCard in matchCards) {
        if (stadiumData.id == matchCard.stadium) {
          count++;
        }
      }

      // Store the result
      result[stadiumData.name] = count;
    }

    result = sortMap(result);
    return result;
  }

  Future<Map<DateTime, double>> getRevenueForEachDate(
      Map<String, List<MatchCard>> matchMap, DateTimeRange week) async {
    Map<DateTime, double> result = {};

    // Get and preprocess owner stadium data
    final List<StadiumData> ownerStadiums =
        await stadiumService.getOwnerStadiumsData();

    // Create a map from stadium ID to its data
    Map<String, StadiumData> stadiumDataMap = {
      for (var stadium in ownerStadiums) stadium.id: stadium
    };

    // Create a map from stadium ID to field ID to price map
    Map<String, Map<String, double>> stadiumFieldPriceMap = {};

    for (var stadium in ownerStadiums) {
      stadiumFieldPriceMap[stadium.id] =
          await stadiumService.generateFieldPriceMap(stadium.id);
    }

    // Iterate over each stadium in matchMap
    for (DateTime date = week.start;
        date.isBefore(week.end) || date.isAtSameMomentAs(week.end);
        date = date.add(const Duration(days: 1))) {
      double dailyRevenue = 0;
      for (var entry in matchMap.entries) {
        String stadiumKey = entry.key;
        List<MatchCard> matchCards = entry.value;

        // Skip if stadiumKey is not in stadiumDataMap
        if (!stadiumDataMap.containsKey(stadiumKey)) continue;

        StadiumData stadiumData = stadiumDataMap[stadiumKey]!;

        for (var matchCard in matchCards) {
          if (stadiumData.fields
              .any((element) => element.id == matchCard.field)) {
            // Use the preprocessed field price map
            Map<String, double> fieldMap = stadiumFieldPriceMap[stadiumKey]!;

            if (fieldMap.containsKey(matchCard.field) &&
                date == parseDateTime(matchCard.date, "00:00")) {
              dailyRevenue += timeStringToDouble(matchCard.playTime) *
                  fieldMap[matchCard.field]!;
            }
          }
        }
      }
      // Store the result
      result[date] = dailyRevenue;
    }
    return result;
  }

  DateTimeRange getDateTimeRangeFromWeekNumber(int weekNumber, int year) {
    DateTime firstDayOfYear = DateTime(year, 1, 1);
    int daysOffset = (weekNumber - 1) * 7;

    DateTime startOfWeek = firstDayOfYear.add(Duration(days: daysOffset));

    while (startOfWeek.weekday != DateTime.monday) {
      startOfWeek = startOfWeek.subtract(Duration(days: 1));
    }
    DateTime endOfWeek =
        startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    return DateTimeRange(start: startOfWeek, end: endOfWeek);
  }

  Future<List<double>> getDataForBarChart(int weekNumber) async {
    DateTime currentDate = DateTime.now();
    DateTimeRange selectedWeek =
        getDateTimeRangeFromWeekNumber(weekNumber, currentDate.year);

    Map<String, List<MatchCard>> matchMap =
        await getFilteredMatch(selectedWeek);

    Map<DateTime, double> revenueMap =
        await getRevenueForEachDate(matchMap, selectedWeek);

    List<double> revenue = List<double>.filled(7, 0.0);

    for (int i = 0; i < 7; i++) {
      DateTime date = selectedWeek.start.add(Duration(days: i));
      revenue[i] = revenueMap[date] ?? 0.0;
    }

    return revenue;
  }

  DateTimeRange getDateTimeRangeFromMonthNumber(int monthNumber, int year) {
    DateTime startOfMonth = DateTime(year, monthNumber, 1);

    DateTime endOfMonth =
        DateTime(year, monthNumber + 1, 1).subtract(Duration(days: 1));

    return DateTimeRange(start: startOfMonth, end: endOfMonth);
  }

  Future<List<double>> getDataForLineChart(int monthNumber) async {
    DateTime currentDate = DateTime.now();
    DateTimeRange selectedMonth =
        getDateTimeRangeFromMonthNumber(monthNumber, currentDate.year);

    Map<String, List<MatchCard>> matchMap =
        await getFilteredMatch(selectedMonth);

    Map<DateTime, double> revenueMap =
        await getRevenueForEachDate(matchMap, selectedMonth);

    int dayInMonth =
        selectedMonth.end.difference(selectedMonth.start).inDays + 1;

    List<double> revenue = List<double>.filled(dayInMonth, 0.0);

    for (int i = 0; i < dayInMonth; i++) {
      DateTime date = selectedMonth.start.add(Duration(days: i));
      revenue[i] = revenueMap[date] ?? 0.0;
    }

    return revenue;
  }
}
