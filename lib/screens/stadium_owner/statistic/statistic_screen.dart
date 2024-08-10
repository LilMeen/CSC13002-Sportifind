import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/widgets/card/statistic_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/widgets/card/line_chart_card.dart';
import 'package:sportifind/widgets/card/bar_chart.dart';
import 'package:sportifind/widgets/card/rank_card.dart';
// import 'package:sportifind/screens/stadium_owner/statistic/statistic_remote_data_source.dart';
// import 'package:sportifind/screens/stadium_owner/statistic/match_data_impl.dart';


class StadiumStatisticScreen extends StatefulWidget {
  const StadiumStatisticScreen({super.key});
  @override
  _StadiumStatisticScreenState createState() => _StadiumStatisticScreenState();
}

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

  bool isWeekly = true;
  late Future<List<MatchCard>> futureMatches;
  List<double> weeklySummary = [];
  late List<MatchCard> matches = [];
  late Map<String, double> dailyRevenue = {};
  List<double> dailySummary = [];
  int selectedMonth = 8; 
  int selectedYear = 2024;

  @override
  void initState() {
    super.initState();
    // futureMatches = fetchMatches();
  }
  int getWeekOfYear(DateTime date) {
  // Get the week number of the date
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int weekOfYear = ((dayOfYear - 1) / 7).floor() + 1;
  return weekOfYear;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MatchCard>>(
        future: futureMatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found'));
          } else {
            List<MatchCard> matches = snapshot.data!;
            //calculateStatistics(matches);
            //dailyRevenue = calculateDailyRevenueForWeek(matches, 32);
            //dailySummary = calculateDailyRevenueForMonth(matches, selectedMonth, selectedYear);

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatisticCard(
                        isUp: true,
                        icon: Icons.attach_money,
                        value: '100,8k',
                        title: 'Revenue',
                        percentage: 15,
                        onPressed: () {
                          print('Card pressed!');
                        },
                      ),
                      const SizedBox(width: 8),
                      StatisticCard(
                        isUp: false,
                        icon: Icons.attach_money,
                        value: '132',
                        title: 'Matches',
                        percentage: 15,
                        onPressed: () {
                          print('Card pressed!');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatisticCard(
                        isUp: false,
                        icon: Icons.attach_money,
                        value: '13h',
                        title: 'Peak hour',
                        percentage: 15,
                        onPressed: () {
                          print('Card pressed!');
                        },
                      ),
                      const SizedBox(width: 8),
                      StatisticCard(
                        isUp: true,
                        icon: Icons.attach_money,
                        value: 'Wednesday',
                        title: 'Peak day',
                        percentage: 15,
                        onPressed: () {
                          print('Card pressed!');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LineChartCard(dailySummary: dailySummary),
                  const SizedBox(height: 10),
                  BarChartComponent(weeklySummary: dailyRevenue.values.toList()),
                  const SizedBox(height: 10),
                  const StadiumRevenueWidget(
                    rank: 1,
                    name: 'Phu Tho',
                    revenue: '92,4k',
                    percentage: 23.22,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class WeeklyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 150, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 100, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 200, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [BarChartRodData(toY: 150, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [BarChartRodData(toY: 100, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [BarChartRodData(toY: 80, color: Colors.lightBlueAccent)],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [BarChartRodData(toY: 50, color: Colors.lightBlueAccent)],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Mon');
                  case 1:
                    return Text('Tue');
                  case 2:
                    return Text('Wed');
                  case 3:
                    return Text('Thu');
                  case 4:
                    return Text('Fri');
                  case 5:
                    return Text('Sat');
                  case 6:
                    return Text('Sun');
                  default:
                    return Text('');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MonthlyLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(7, 10),
              FlSpot(8, 20),
              FlSpot(9, 30),
              FlSpot(10, 40),
              FlSpot(11, 50),
              FlSpot(12, 60),
              FlSpot(13, 70),
              FlSpot(14, 80),
              FlSpot(15, 90),
              FlSpot(16, 100),
              FlSpot(17, 110),
              FlSpot(18, 120),
              FlSpot(19, 130),
              FlSpot(20, 140),
              FlSpot(21, 150),
            ],
            isCurved: true,
            color: Colors.purple,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
      ),
    );
  }
}
