import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/stadium_owner/statistic/month_navigator.dart';
import 'package:sportifind/screens/stadium_owner/statistic/week_navigator.dart';
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

class _StadiumStatisticScreenState extends State<StadiumStatisticScreen> {
  bool isWeekly = true;
  late Future<List<MatchCard>> futureMatches;
  List<double> weeklySummary = [];
  late List<MatchCard> matches = [];
  late Map<String, double> dailyRevenue = {};
  List<double> dailySummary = [];
  late int selectedWeek;
  late int selectedMonth;
  int selectedYear = 2024;
  int status = 0;

  @override
  void initState() {
    super.initState();
    selectedWeek = _getCurrentWeekNumber();
    selectedMonth = _getCurrentMonthNumber();
  }

  int _getCurrentWeekNumber() {
    DateTime now = DateTime.now();
    int dayOfYear = int.parse(DateFormat("D").format(now));
    return ((dayOfYear - now.weekday + 10) / 7).floor();
  }

  int _getCurrentMonthNumber() {
  DateTime now = DateTime.now();
  return now.month;
}

  void _handleWeekNumberChanged(int weekNumber) {
    setState(() {
      selectedWeek = weekNumber;
      print('Updated Selected Week Number: $selectedWeek');
    });
  }

  void _handleMonthNumberChanged(int monthNumber) {
    setState(() {
      print('hehe');
      selectedMonth = monthNumber;
      print('Updated Selected Month Number: $selectedMonth'); 
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
            // status == 0
            //     ? WeeklyBarChart()
            //     : MonthlyLineChart(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
