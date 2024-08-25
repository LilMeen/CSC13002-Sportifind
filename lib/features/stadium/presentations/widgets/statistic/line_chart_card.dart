import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/stadium/presentations/widgets/statistic/custom_card.dart';
import 'package:sportifind/features/stadium/presentations/widgets/statistic/line_data.dart';

class LineChartCard extends StatelessWidget {
  final List<double> dailySummary;

  const LineChartCard({super.key, required this.dailySummary});

  @override
  Widget build(BuildContext context) {
    double maxY = calculateMaxY(dailySummary);
    final data = LineData(dailySummary, maxY, generateLeftTitles(maxY));

    return CustomCard(
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
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 30,
                    maxContentWidth: 80,
                    getTooltipColor: (LineBarSpot spot) => Colors.white,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          touchedSpot.y.toStringAsFixed(2),
                          TextStyle(color: SportifindTheme.bluePurple),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 5, 
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.blueGrey[100],
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                    data.bottomTitle[value.toInt()].toString(),
                                    style: SportifindTheme.titleChart),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        String? title = data.leftTitle[value];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            title ?? '',
                            style: SportifindTheme.titleChart,
                          ),
                        );
                      },
                      showTitles: true,
                      interval: maxY / 5,             
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.023,
                    color: const Color.fromARGB(255, 3, 6, 194),
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [SportifindTheme.bluePurple, Colors.white],
                      ),
                      show: true,
                    ),
                    dotData: const FlDotData(show: false),
                    spots: data.spots,
                  )
                ],
                minX: 0,
                maxX: 30,
                maxY: maxY,
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double calculateMaxY(List<double> dailySummary) {
  double maxRevenue = dailySummary.reduce((a, b) => a > b ? a : b);
  double roundedMaxY = ((maxRevenue / 100).ceil() * 100) + 100;
  return roundedMaxY;
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

Map<double, String> generateLeftTitles(double maxY) {
  Map<double, String> titles = {};
  int intervals = 5; // You can adjust this for more or fewer intervals
  double interval = maxY / intervals;

  for (int i = 0; i <= intervals; i++) {
    double value = i * interval;
    titles[value] = formatNumber(value);
  }

  return titles;
}
