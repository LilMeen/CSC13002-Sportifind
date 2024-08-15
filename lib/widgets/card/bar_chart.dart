import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/widgets/card/bar_data.dart';

class BarChartComponent extends StatelessWidget {
  const BarChartComponent({super.key, required this.weeklySummary});
  final List<double> weeklySummary;

  @override
  Widget build(BuildContext context) {
    double maxYValue =
        (weeklySummary.reduce((a, b) => a > b ? a : b) / 100).ceil() * 100 +
            100;

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
      padding: const EdgeInsets.all(12.0),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Total Revenue",
                    style: SportifindTheme.textBluePurple.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                child: BarChart(
                  BarChartData(
                    maxY: maxYValue,
                    minY: 0,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: maxYValue / 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300]!,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxYValue / 5,
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
                                color: SportifindTheme.bluePurple,
                                width: 25,
                                borderRadius: BorderRadius.circular(30),
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
                    barTouchData: BarTouchData(
                      enabled: true, // Enable touch interaction
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => SportifindTheme
                            .bluePurple, // Set the tooltip background color to blue
                        //tooltipMargin: 8,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipRoundedRadius: 30,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.toInt()}', // Tooltip value
                            const TextStyle(
                              color: Colors.white, // Tooltip text color
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (event.isInterestedForInteractions &&
                            barTouchResponse != null &&
                            barTouchResponse.spot != null) {
                        }
                      },
                      handleBuiltInTouches:
                          true, 
                    ),
                  ),
                ),
              ),
            ],
      ),
    );
  }

  String formatNumber(double value) {
  if (value < 1000) {
    double roundedValue = (value / 100).roundToDouble() * 100;
    return roundedValue.toInt().toString();
  } else {
    double roundedValue;
    if (value < 1000000) {
      roundedValue = ((value / 1000).ceil() * 1000).toDouble();
      return '${(roundedValue / 1000).toInt()}k';
    } else {
      roundedValue = ((value / 1000000).ceil() * 1000000).toDouble();
      return '${(roundedValue / 1000000).toInt()}M';
    }
  }
}

  Widget getLeftTitles(double value, TitleMeta meta, double maxYValue) {
    TextStyle style = SportifindTheme.titleChart;

    int desiredIntervals = 5;
    double interval = maxYValue / desiredIntervals;

    double roundedValue = (value / interval).round() * interval;

    if ((value - roundedValue).abs() < 0.1) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(formatNumber(roundedValue), style: style),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    TextStyle style = SportifindTheme.titleChart;

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Mon', style: style);
        break;
      case 1:
        text = Text('Tue', style: style);
        break;
      case 2:
        text = Text('Wed', style: style);
        break;
      case 3:
        text = Text('Thu', style: style);
        break;
      case 4:
        text = Text('Fri', style: style);
        break;
      case 5:
        text = Text('Sat', style: style);
        break;
      case 6:
        text = Text('Sun', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
