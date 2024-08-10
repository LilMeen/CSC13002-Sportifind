import 'package:flutter/material.dart';

class StadiumRevenueWidget extends StatelessWidget {
  final int rank;
  final String name;
  final String revenue;
  final double percentage;

  const StadiumRevenueWidget({
    required this.rank,
    required this.name,
    required this.revenue,
    required this.percentage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 19),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 202, 202, 202)),
        borderRadius: BorderRadius.circular(6),
      ),
      width: 274,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$rank',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 24,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                revenue,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 50,),
          CircularPercentageIndicator(percentage: percentage),
        ],
      ),
    );
  }
}

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;

  const CircularPercentageIndicator({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58, // Set the desired width
      height: 58, // Set the desired height
      child: CustomPaint(
        painter: CircularIndicatorPainter(percentage),
        child: Center(
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Increase font size
          ),
        ),
      ),
    );
  }
}


class CircularIndicatorPainter extends CustomPainter {
  final double percentage;

  CircularIndicatorPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    Paint foregroundPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - 4;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * 3.141592653589793 * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}