import 'package:fl_chart/fl_chart.dart';

class LineData {
  final List<double> dailySummary;
  final double maxY;
  final Map<double, String> leftTitle;

  LineData(this.dailySummary, this.maxY, this.leftTitle);

  List<FlSpot> get spots {
    return List.generate(dailySummary.length, (index) {
      return FlSpot(index.toDouble(), dailySummary[index]);
    });
  }

  final bottomTitle = {
    0: '1',
    5: '6',
    10: '11',
    15: '16',
    20: '21',
    25: '26',
    30: '31',
  };
}
