import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/stadium_owner/statistic/month_navigator.dart';
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
  late int getTotalMatch;
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
  late Map<DateTime, int> mostDate;
  late Map<DateTime, double> dailyRevenue;
  DateTime now = DateTime.now();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedWeek = _getCurrentWeekNumber();
    selectedMonth = _getCurrentMonthNumber();
    _loadWeeklySummary(selectedWeek);
    _loadMonthlySummary(selectedMonth);
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
      print('Updated Selected Week Number: $selectedWeek');
    });
  }

  void _handleMonthNumberChanged(int monthNumber) {
    setState(() {
      print('hehe');
      selectedMonth = monthNumber;
      _loadMonthlySummary(monthNumber);
      print('Updated Selected Month Number: $selectedMonth');
    });
  }

  Future<void> _loadWeeklySummary(int weekNumber) async {
    setState(() {
      isLoading = true;
    });

    weeklySummary = await statisticService.getDataForBarChart(weekNumber);
    DateTimeRange range = statisticService.getDateTimeRangeFromWeekNumber(weekNumber, now.year);
    getTotalMatch = await statisticService.getTotalMatch(range);
    print('Total match: $getTotalMatch');

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMonthlySummary(int monthNumber) async {
    setState(() {
      isLoading = true;
    });

    dailySummary = await statisticService.getDataForLineChart(monthNumber);
    DateTimeRange range = statisticService.getDateTimeRangeFromMonthNumber(monthNumber, now.year);
    getTotalMatch = await statisticService.getTotalMatch(range);
    print('Total match: $getTotalMatch');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
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
            isLoading
              ? CircularProgressIndicator()
              : status == 0
                  ? BarChartComponent(weeklySummary: weeklySummary)
                  : LineChartCard(dailySummary: dailySummary),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
