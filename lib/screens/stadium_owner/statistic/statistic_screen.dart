import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/stadium_owner/statistic/month_navigator.dart';
import 'package:sportifind/screens/stadium_owner/statistic/week_navigator.dart';
import 'package:sportifind/util/statistic_service.dart';
import 'package:sportifind/widgets/card/statistic_card.dart';
import 'package:sportifind/widgets/card/line_chart_card.dart';
import 'package:sportifind/widgets/card/bar_chart.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StadiumStatisticScreen extends StatefulWidget {
  const StadiumStatisticScreen({super.key});

  @override
  _StadiumStatisticScreenState createState() => _StadiumStatisticScreenState();
}

int status = 0;

class _StadiumStatisticScreenState extends State<StadiumStatisticScreen> {
  StatisticService statisticService = StatisticService();

  bool isWeekly = true;
  List<double> weeklySummary = [];

  late Map<String, List<MatchCard>> matchesMap = {};
  List<double> dailySummary = [];
  List<double> dummySummary = List.filled(31, 0);
  late int selectedWeek;
  late int lastSelectedWeek;
  late int selectedMonth;
  late int lastSelectedMonth;
  int selectedYear = 2024;
  DateFormat dateFormat = DateFormat('EEEE');
  DateFormat dateFornatDate = DateFormat('dd/MM/yyyy');

  String? dayOfWeek;
  late Map<String, double> stadiumRevenue;
  double? weeklyRevenue;
  double? lastWeekRevenue;
  double? monthlyRevenue;
  double? lastMonthRevenue;

  int? weeklyMatch;
  int? lastWeekMatch;
  int? monthlyMatch;
  int? lastMonthMatch;

  late double getWeekTotalRevenue;
  late double getMonthTotalRevenue;

  late Map<String, int> weekHotStadium;
  late Map<String, int> monthHotStadium;

  late Map<DateTime, int> weekPeakDate;
  late Map<DateTime, int> lastWeekPeakDate;
  late Map<DateTime, int> monthPeakDate;
  late Map<DateTime, int> lastMonthPeakDate;

  late Map<DateTime, double> dailyRevenue;
  DateTime now = DateTime.now();

  bool isLoading = true;
  String? errorMessage;
  bool isWeekSelected = true;
  bool isMonthSelected = true;
  int lastSelectedWeekOffset = 0;
  int lastSelectedMonthOffset = 0;

  Future<void>? _loadDataFuture;

  @override
  void initState() {
    super.initState();
    selectedWeek = _getCurrentWeekNumber();
    lastSelectedWeek = selectedWeek;
    selectedMonth = _getCurrentMonthNumber();
    lastSelectedMonth = selectedMonth;
    _loadDataFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _loadWeeklySummary(selectedWeek);
      await _loadMonthlySummary(selectedMonth);
    } catch (e) {
      print('Error loading initial data: $e');
      setState(() {
        errorMessage = 'Failed to load initial data. Please try again.';
      });
    }
  }

  int _getCurrentWeekNumber() {
    int dayOfYear = int.parse(DateFormat("DD").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  int _getCurrentMonthNumber() {
    return now.month;
  }

  void _handleWeekNumberChanged(int weekNumber) {
    setState(() {
      selectedWeek = weekNumber;
      lastSelectedWeek = weekNumber - 1;
      _loadWeeklySummary(weekNumber);
    });
  }

  void _handleMonthNumberChanged(int monthNumber) {
    setState(() {
      selectedMonth = monthNumber;
      lastSelectedMonth = monthNumber - 1;
      _loadMonthlySummary(monthNumber);
    });
  }

  Future<void> _loadWeeklySummary(int weekNumber) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      weeklySummary = await statisticService.getDataForBarChart(weekNumber);

      DateTimeRange currentRange =
          statisticService.getDateTimeRangeFromWeekNumber(weekNumber, now.year);

      int currentWeekTotalMatch =
          await statisticService.getTotalMatch(currentRange);
      Map<String, List<MatchCard>> currentMatchesMap =
          await statisticService.getFilteredMatch(currentRange);
      Map<String, double> currentStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(currentMatchesMap);
      double currentWeekRevenue =
          statisticService.getTotalRevenue(currentStadiumRevenue);
      Map<String, int> currentHotStadium =
          await statisticService.getMatchesEachStadium(currentMatchesMap);
      Map<DateTime, int> currentPeakDate =
          await statisticService.getMostDate(currentRange);

      DateTimeRange previousRange = statisticService
          .getDateTimeRangeFromWeekNumber(weekNumber - 1, now.year);

      Map<String, List<MatchCard>> previousMatchesMap =
          await statisticService.getFilteredMatch(previousRange);
      Map<String, double> previousStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(previousMatchesMap);
      Map<DateTime, int> previousPeakDate =
          await statisticService.getMostDate(previousRange);
      double previousWeekRevenue =
          statisticService.getTotalRevenue(previousStadiumRevenue);
      int previousWeekMatch =
          await statisticService.getTotalMatch(previousRange);

      setState(() {
        getWeekTotalRevenue = currentWeekRevenue;
        weeklyRevenue = currentWeekRevenue;
        lastWeekRevenue = previousWeekRevenue;
        weeklyMatch = currentWeekTotalMatch;
        lastWeekMatch = previousWeekMatch;
        matchesMap = currentMatchesMap;
        stadiumRevenue = currentStadiumRevenue;
        weekHotStadium = currentHotStadium;
        weekPeakDate = currentPeakDate;
        lastWeekPeakDate = previousPeakDate;
      });
    } catch (e) {
      print('Error loading weekly summary: $e');
      setState(() {
        errorMessage = 'Failed to load weekly data. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMonthlySummary(int monthNumber) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      dailySummary = await statisticService.getDataForLineChart(monthNumber);

      DateTimeRange currentRange = statisticService
          .getDateTimeRangeFromMonthNumber(monthNumber, now.year);

      int currentMonthTotalMatch =
          await statisticService.getTotalMatch(currentRange);
      Map<String, List<MatchCard>> currentMatchesMap =
          await statisticService.getFilteredMatch(currentRange);
      Map<String, double> currentStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(currentMatchesMap);
      double currentMonthRevenue =
          statisticService.getTotalRevenue(currentStadiumRevenue);
      Map<String, int> currentHotStadium =
          await statisticService.getMatchesEachStadium(currentMatchesMap);
      Map<DateTime, int> currentPeakDate =
          await statisticService.getMostDate(currentRange);

      DateTimeRange previousRange = statisticService
          .getDateTimeRangeFromMonthNumber(monthNumber - 1, now.year);

      Map<String, List<MatchCard>> previousMatchesMap =
          await statisticService.getFilteredMatch(previousRange);
      Map<String, double> previousStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(previousMatchesMap);
      Map<DateTime, int> previousPeakDate =
          await statisticService.getMostDate(previousRange);
      double previousMonthRevenue =
          statisticService.getTotalRevenue(previousStadiumRevenue);
      int previousMonthMatch =
          await statisticService.getTotalMatch(previousRange);

      setState(() {
        getMonthTotalRevenue = currentMonthRevenue;
        monthlyRevenue = currentMonthRevenue;
        lastMonthRevenue = previousMonthRevenue;
        monthlyMatch = currentMonthTotalMatch;
        lastMonthMatch = previousMonthMatch;
        matchesMap = currentMatchesMap;
        stadiumRevenue = currentStadiumRevenue;
        monthHotStadium = currentHotStadium;
        monthPeakDate = currentPeakDate;
        lastMonthPeakDate = previousPeakDate;
      });
    } catch (e) {
      print('Error loading monthly summary: $e');
      setState(() {
        errorMessage = 'Failed to load monthly data. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatNumber(double value) {
    if (value == 0) return '0';
    if (value < 100) {
      return value.toStringAsFixed(1);
    }
    if (value < 1000) {
      return value.toInt().toString();
    } else if (value < 1000000) {
      double roundedValue = (value / 1000).roundToDouble();
      return '${roundedValue.toStringAsFixed(1)}k';
    } else {
      double roundedValue = (value / 1000000).roundToDouble();
      return '${roundedValue.toStringAsFixed(1)}M';
    }
  }

  @override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Scaffold(
    body: FutureBuilder(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || errorMessage != null) {
          return Center(
              child: Text(
                  errorMessage ?? 'An error occurred. Please try again.'));
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ToggleSwitch(
                  minWidth: width - 80,
                  minHeight: 50.0,
                  initialLabelIndex: status,
                  cornerRadius: 8.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: SportifindTheme.whiteEdgar,
                  inactiveFgColor: SportifindTheme.bluePurple,
                  totalSwitches: 2,
                  radiusStyle: true,
                  labels: const ['Week', 'Month'],
                  fontSize: 20.0,
                  activeBgColors: const [
                    [Color.fromARGB(255, 76, 59, 207)],
                    [Color.fromARGB(255, 76, 59, 207)],
                  ],
                  animate: true,
                  curve: Curves.fastOutSlowIn,
                  onToggle: (index) {
                    setState(() {
                      status = index!;
                      isLoading = true; 

                      if (status == 0) {
                        isWeekSelected = true;
                        isMonthSelected = false;
                        _loadWeeklySummary(selectedWeek).then((_) {
                          setState(() {
                            isLoading = false; 
                          });
                        });
                      } else {
                        isMonthSelected = true;
                        isWeekSelected = false;
                        _loadMonthlySummary(selectedMonth).then((_) {
                          setState(() {
                            isLoading = false; // Stop loading after data is loaded
                          });
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                status == 0
                    ? WeekNavigator(
                        selectedWeek: lastSelectedWeekOffset,
                        onWeekNumberChanged: (newWeek) {
                          setState(() {
                            lastSelectedWeekOffset = newWeek;
                            _loadWeeklySummary(lastSelectedWeekOffset);
                          });
                        },
                      )
                    : MonthNavigator(
                        selectedMonth: selectedMonth,
                        onMonthNumberChanged: (newMonth) {
                          setState(() {
                            lastSelectedMonthOffset = newMonth;
                            _loadMonthlySummary(lastSelectedMonthOffset);
                          });
                        },
                      ),
                const SizedBox(height: 10),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()) // Show loading spinner for charts and cards
                else ...[
                  status == 0
                      ? BarChartComponent(weeklySummary: weeklySummary)
                      : LineChartCard(dailySummary: dailySummary),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          StatisticCard(
                            status: 0,
                            icon: Icons.attach_money,
                            value: status == 0
                                ? formatNumber(weeklyRevenue!)
                                : formatNumber(monthlyRevenue!),
                            title: 'Revenue',
                            percentage: status == 0
                                ? ((weeklyRevenue ?? 0) -
                                        (lastWeekRevenue ?? 0)) /
                                    (lastWeekRevenue ?? 1) *
                                    100
                                : ((monthlyRevenue ?? 0) -
                                        (lastMonthRevenue ?? 0)) /
                                    (lastMonthRevenue ?? 1) *
                                    100,
                            onPressed: () {},
                          ),
                          const Spacer(),
                          StatisticCard(
                            status: 1,
                            icon: Icons.sports_soccer,
                            value: status == 0
                                ? weeklyMatch.toString()
                                : monthlyMatch.toString(),
                            title: 'Matches',
                            totalMatches: status == 0
                                ? weeklyMatch! - lastWeekMatch!
                                : monthlyMatch! - lastMonthMatch!,
                            onPressed: () {},
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Spacer(),
                          StatisticCard(
                            status: 1,
                            icon: Icons.calendar_today,
                            value: status == 0
                                ? dateFormat.format(weekPeakDate.keys.last)
                                : dateFornatDate.format(
                                    monthPeakDate.keys.last),
                            title: 'Hot Day',
                            totalMatches: status == 0
                                ? weekPeakDate.values.last -
                                    lastWeekPeakDate.values.last
                                : monthPeakDate.values.last -
                                    lastMonthPeakDate.values.last,
                            onPressed: () {},
                          ),
                          const Spacer(),
                          StatisticCard(
                            status: 2,
                            icon: Icons.stadium,
                            value: status == 0
                                ? weekHotStadium.keys.last.toString()
                                : monthHotStadium.keys.last.toString(),
                            title: 'Hot Stadium',
                            stadiumMatches: status == 0
                                ? weekHotStadium.values.last
                                : monthHotStadium.values.last,
                            onPressed: () {},
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }
      },
    ),
  );
}

}
