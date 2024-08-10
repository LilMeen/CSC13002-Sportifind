import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/widgets/card/bar_data.dart';

class BarChartComponent extends StatelessWidget {
  const BarChartComponent({super.key, required this.weeklySummary});
  final List<double> weeklySummary;

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum value in the weekly summary and adjust the max Y value
    double maxYValue = (weeklySummary.reduce((a, b) => a > b ? a : b) / 100).ceil() * 100 + 100;

    BarData myBarData = BarData(
      monAmount: weeklySummary[0],
      tueAmount: weeklySummary[1],
      wedAmount: weeklySummary[2],
      thuAmount: weeklySummary[3],
      friAmount: weeklySummary[4],
      satAmount: weeklySummary[5],
      sunAmount: weeklySummary[6],
    );

    myBarData.initializeBarData();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: maxYValue,
            minY: 0,
            gridData: FlGridData(drawVerticalLine: true),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Increased reserved size for larger labels
                  getTitlesWidget: (value, meta) {
                    return getLeftTitles(value, meta, maxYValue);
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: getBottomTitles,
                ),
              ),
            ),
            barGroups: myBarData.barData
                .map(
                  (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                        toY: data.y,
                        color: Colors.blueGrey,
                        width: 25,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxYValue,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta, double maxYValue) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

    Widget text;
    double interval = maxYValue / 4;
    if (value == 0) {
      text = Text('0', style: style);
    } else if (value == maxYValue) {
      text = Text('${maxYValue.toInt()}', style: style);
    } else if (value == interval || value == interval * 2 || value == interval * 3) {
      text = Text('${value.toInt()}', style: style);
    } else {
      text = Text('', style: style);
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
