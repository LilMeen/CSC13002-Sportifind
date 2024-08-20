import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/team/widgets/app_bar.dart';
import 'package:sportifind/screens/stadium_owner/statistic/month_navigator.dart';
import 'package:sportifind/screens/stadium_owner/statistic/ranking_screen.dart';
import 'package:sportifind/screens/stadium_owner/statistic/week_navigator.dart';
import 'package:sportifind/util/statistic_service.dart';
import 'package:sportifind/widgets/card/statistic_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/widgets/card/line_chart_card.dart';
import 'package:sportifind/widgets/card/bar_chart.dart';
import 'package:sportifind/widgets/card/rank_card.dart';
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
  late int selectedMonth;
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

  late int getTotalMatch;
  late double getTotalRevenue;
  late Map<DateTime, int> mostDate;

  late Map<DateTime, double> dailyRevenue;
  DateTime now = DateTime.now();

  bool isLoading = true;
  String? errorMessage;

  Future<void>? _loadDataFuture;

  @override
  void initState() {
    super.initState();
    selectedWeek = _getCurrentWeekNumber();
    selectedMonth = _getCurrentMonthNumber();
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
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  int _getCurrentMonthNumber() {
    return now.month;
  }

  void _handleWeekNumberChanged(int weekNumber) {
    setState(() {
      selectedWeek = weekNumber;
      _loadWeeklySummary(weekNumber);
    });
  }

  void _handleMonthNumberChanged(int monthNumber) {
    setState(() {
      selectedMonth = monthNumber;
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

      DateTimeRange previousRange = statisticService
          .getDateTimeRangeFromWeekNumber(weekNumber - 1, now.year);

      Map<String, List<MatchCard>> previousMatchesMap =
          await statisticService.getFilteredMatch(previousRange);
      Map<String, double> previousStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(previousMatchesMap);
      double previousWeekRevenue =
          statisticService.getTotalRevenue(previousStadiumRevenue);
      int previousWeekMatch =
          await statisticService.getTotalMatch(previousRange);    

      setState(() {
        getTotalMatch = currentWeekTotalMatch;
        getTotalRevenue = currentWeekRevenue;
        weeklyRevenue = currentWeekRevenue;
        lastWeekRevenue = previousWeekRevenue;
        weeklyMatch = currentWeekTotalMatch;
        lastWeekMatch = previousWeekMatch;
        matchesMap = currentMatchesMap;
        stadiumRevenue = currentStadiumRevenue;
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

      DateTimeRange previousRange = statisticService
          .getDateTimeRangeFromMonthNumber(monthNumber - 1, now.year);

      Map<String, List<MatchCard>> previousMatchesMap =
          await statisticService.getFilteredMatch(previousRange);
      Map<String, double> previousStadiumRevenue =
          await statisticService.getRevenueOfEachStadium(previousMatchesMap);
      double previousMonthRevenue =
          statisticService.getTotalRevenue(previousStadiumRevenue);
      int previousMonthMatch =
          await statisticService.getTotalMatch(previousRange);    


      setState(() {
        getTotalMatch = currentMonthTotalMatch;
        getTotalRevenue = currentMonthRevenue;
        monthlyRevenue = currentMonthRevenue;
        lastMonthRevenue = previousMonthRevenue;
        monthlyMatch = currentMonthTotalMatch;
        lastMonthMatch = previousMonthMatch;
        matchesMap = currentMatchesMap;
        stadiumRevenue = currentStadiumRevenue;
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
      //appBar: SportifindAppBar,
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
                      if (status == 0) {
                        _loadWeeklySummary(selectedWeek);
                      } else {
                        _loadMonthlySummary(selectedMonth);
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                status == 0
                    ? WeekNavigator(
                        selectedWeek: selectedWeek,
                        onWeekNumberChanged: _handleWeekNumberChanged,
                      )
                    : MonthNavigator(
                        selectedMonth: selectedMonth,
                        onMonthNumberChanged: _handleMonthNumberChanged,
                      ),
                const SizedBox(height: 10),
                status == 0
                    ? BarChartComponent(weeklySummary: weeklySummary)
                    : LineChartCard(dailySummary: dailySummary),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  const Spacer(),
                                  StatisticCard(
                                    icon: Icons.attach_money,
                                    value: formatNumber(getTotalRevenue),
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
                                    isText: false,
                                    onPressed: () {},
                                  ),
                                  const Spacer(),
                                  StatisticCard(
                                    icon: Icons.sports_soccer,
                                    value: getTotalMatch.toString(),
                                    title: 'Matches',
                                    percentage: status == 0
                                        ? ((weeklyMatch ?? 0) -
                                                (lastWeekMatch ?? 0)) /
                                            (lastWeekMatch ?? 1) *
                                            100
                                        : ((monthlyMatch ?? 0) -
                                                (lastMonthRevenue ?? 0)) /
                                            (lastMonthRevenue ?? 1) *
                                            100,
                                    isText: false,
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
                                    icon: Icons.calendar_today,
                                    value: status == 0
                                        ? weeklyRevenue.toString()
                                        : monthlyRevenue.toString(),
                                    title: 'Hot Day',
                                    percentage: status == 0
                                        ? ((weeklyRevenue ?? 0) -
                                                (lastWeekRevenue ?? 0)) /
                                            (lastWeekRevenue ?? 1) *
                                            100
                                        : ((monthlyRevenue ?? 0) -
                                                (lastMonthRevenue ?? 0)) /
                                            (lastMonthRevenue ?? 1) *
                                            100,
                                    isText: false,
                                    onPressed: () {},
                                  ),
                                  const Spacer(),
                                  StatisticCard(
                                    icon: Icons.stadium,
                                    value: getTotalMatch.toString(),
                                    title: 'Hot Stadium',
                                    percentage: 0,
                                    isText: true,
                                    onPressed: () {},
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ));
          }
        },
      ),
    );
  }
}
