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
  // bool isWeekly = true;

  // late List<MatchDataModel> matches;
  // void fetchMatchesData() async{
  // matches = await fetchMatches();
  // calculateStatistics(matches);
  // }
  // late List<double> weeklySummary = calculateDailyRevenue(matches) as List<double>;

  // List<double> weeklySummary = [
  //     4.40,
  //     2.50,
  //     42.42,
  //     10.50,
  //     100.20,
  //     88.99,
  //     90.10,
  //     23.44,
  //   ];

  StatisticService statisticService = StatisticService();

  bool isWeekly = true;
  List<double> weeklySummary = [];
  late Map<String, List<MatchCard>> matchesMap = {};
  List<double> dailySummary = [];
  late int selectedWeek;
  late int selectedMonth;
  int selectedYear = 2024;
  DateFormat dateFornat = DateFormat('EEEE');
  DateFormat dateFornatDate = DateFormat('dd/MM/yyyy');

  String? dayOfWeek;
  late Map<String, double> stadiumRevenue;
  double? weelkyRevenue;
  double? lastWeekRevenue;
  double? monthlyRevenue;
  double? lastMonthRevenue;
  late Map<DateTime, int> mostDate;
  late Map<DateTime, double> dailyRevenue;

  bool isloading = true;

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
