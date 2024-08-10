import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sportifind/widgets/card/line_chart_data.dart';
import 'package:sportifind/widgets/card/custom_card.dart';

class LineChartCard extends StatelessWidget {
  final List<double> dailySummary;

  LineChartCard({super.key, required this.dailySummary});

  @override
  Widget build(BuildContext context) {
    double maxY = calculateMaxY(dailySummary);
    final data = LineData(dailySummary, maxY, generateLeftTitles(maxY));

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Revenue",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                    getTooltipColor: (LineBarSpot spot) => Color.fromARGB(255, 232, 232, 232),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          touchedSpot.y.toStringAsFixed(2),
                          const TextStyle(color: Color.fromARGB(255, 3, 6, 194)),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: const FlGridData(show: false),
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
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[400])),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.leftTitle[value] != null
                            ? Text(data.leftTitle[value] ?? '',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[400]))
                            : const SizedBox();
                      },
                      showTitles: true,
                      interval: maxY / 4,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,  // Smooth lines
                    curveSmoothness: 0.023,  // Adjust smoothness here
                    color: const Color.fromARGB(255, 3, 6, 194),
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(255, 74, 38, 172).withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                      show: true,
                    ),
                    dotData: FlDotData(show: false),
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

Map<double, String> generateLeftTitles(double maxY) {
  return {
    0: '0',
    maxY * 0.25: (maxY * 0.25).toInt().toString(),
    maxY * 0.5: (maxY * 0.5).toInt().toString(),
    maxY * 0.75: (maxY * 0.75).toInt().toString(),
    maxY: maxY.toInt().toString(),
  };
}
