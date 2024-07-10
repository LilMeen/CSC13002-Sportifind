import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/profile/widgets/rating.dart';
import 'dart:math';


class Hexagon extends StatelessWidget {
  const Hexagon({super.key, required this.screenWidth, required this.ratings});

  final double screenWidth;
  final List<Rating> ratings;
  double get diameter => screenWidth - 200;
  double get radius => diameter / 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: diameter,
        height: diameter,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Labels(radius: radius, diameter: diameter, ratings: ratings),
            CustomPaint(painter: HexagonPainter(radius: radius)),
            ClipPath(
              clipper: HexagonClipper(
                radius: radius,
                multipliers: ratings.map((rating) => rating.value / 100.0).toList(),
              ),
              child: SizedBox(
                width: diameter,
                height: diameter,
                child: ColoredBox(
                  color: Colors.teal.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  final double radius;
  final List<double> multipliers;

  HexagonClipper({required this.radius, required this.multipliers});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final Path path = Path();

    final angleMul = [1, 3, 5, 7, 9, 11];
    path.addPolygon(
      [
        for (int i = 0; i < 6; i++)
          Offset(
            radius * multipliers[i] *
                    cos(pi * 2 * (angleMul[i] * 30) / 360) +
                center.dx,
            radius * multipliers[i] *
                    sin(pi * 2 * (angleMul[i] * 30) / 360) +
                center.dy,
          ),
      ],
      true,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Labels extends StatelessWidget {
  const Labels({
    Key? key,
    required this.radius,
    required this.diameter,
    required this.ratings,
  }) : super(key: key);

  final double radius, diameter;
  final List<Rating> ratings;

  @override
  Widget build(BuildContext context) {
    final center = Offset(diameter / 2, diameter / 2);

    return Stack(
      children: [
        for (int i = 0; i < 6; i++)
          Positioned(
            top: center.dy - radius * 1.5, // Adjust the multiplier as needed
            left: center.dx +
                radius *
                    cos(pi / 3 * i + pi / 6), // Adjust the angle for hexagon vertices
            child: SizedBox(
              width: 80,
              height: 60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ratings[i].name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ratings[i].value.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}



class HexagonPainter extends CustomPainter {
  HexagonPainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.blueGrey.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.width / 2);
    final angleMul = [1, 3, 5, 7, 9, 11];

    for (int j = 1; j <= 5; j++) {
      for (int i = 0; i < 6; i++) {
        canvas.drawLine(
          Offset(
            j / 5 *
                    radius *
                    cos(pi * 2 * (angleMul[i] * 30 / 360)) +
                center.dx,
            j / 5 *
                    radius *
                    sin(pi * 2 * (angleMul[i] * 30 / 360)) +
                center.dy,
          ),
          Offset(
            j / 5 *
                    radius *
                    cos(pi * 2 * (angleMul[(i + 1) % 6] * 30 / 360)) +
                center.dx,
            j / 5 *
                    radius *
                    sin(pi * 2 * (angleMul[(i + 1) % 6] * 30 / 360)) +
                center.dy,
          ),
          borderPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}