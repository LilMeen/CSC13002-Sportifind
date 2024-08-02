import 'package:flutter/material.dart';
import 'package:sportifind/screens/player/profile/widgets/rating.dart';
import 'dart:math';

class Hexagon extends StatelessWidget {
  const Hexagon({super.key, required this.screenWidth, required this.ratings});

  final double screenWidth;
  final List<Rating> ratings;
  double get diameter => screenWidth - 200; // Increase size
  double get radius => diameter / 2;

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   child: Center(
    //     child: Container(
    //       width: diameter,
    //       height: diameter,
          return Center(
            child: SizedBox(
              width: diameter + 100,
              height: diameter + 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Labels(radius: radius, diameter: diameter, ratings: ratings),
                  CustomPaint(painter: HexagonPainter(radius: radius), size: Size(diameter, diameter)),
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
                     //   ),
                    //   ),
                    // ),
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
            radius * multipliers[i] * cos(pi * 2 * (angleMul[i] * 30) / 360) + center.dx,
            radius * multipliers[i] * sin(pi * 2 * (angleMul[i] * 30) / 360) + center.dy,
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
    super.key,
    required this.radius,
    required this.diameter,
    required this.ratings,
  });

  final double radius, diameter;
  final List<Rating> ratings;

  @override
  Widget build(BuildContext context) {
    final center = Offset(diameter / 2 + 50, diameter / 2 + 50);
    const style = TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      );

    return Center(
      child: Stack(
        children: [
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 30 / 360) + center.dx + 30,
                radius * sin(pi * 2 * 30 / 360) + center.dy,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[0].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[0].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 90 / 360) + center.dx,
                radius * sin(pi * 2 * 90 / 360) + center.dy + 30,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[1].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[1].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 150 / 360) + center.dx - 30,
                radius * sin(pi * 2 * 150 / 360) + center.dy,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[2].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[2].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 210 / 360) + center.dx - 30,
                radius * sin(pi * 2 * 210 / 360) + center.dy,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[3].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[3].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 270 / 360) + center.dx,
                radius * sin(pi * 2 * 270 / 360) + center.dy - 30,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[4].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[4].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                radius * cos(pi * 2 * 330 / 360) + center.dx + 30,
                radius * sin(pi * 2 * 330 / 360) + center.dy,
              ),
            width: 100,
            height: 40,
            ),
            child: Center(
              child: Column(
                children:[
                  Text(ratings[5].name, textAlign: TextAlign.center, style: style),
                  Text(ratings[5].value.toString(),textAlign: TextAlign.center, style: style),
                ]
              )
            ),
          ),
        ],
      ),
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
            j / 5 * radius * cos(pi * 2 * (angleMul[i] * 30 / 360)) + center.dx,
            j / 5 * radius * sin(pi * 2 * (angleMul[i] * 30 / 360)) + center.dy,
          ),
          Offset(
            j / 5 * radius * cos(pi * 2 * (angleMul[(i + 1) % 6] * 30 / 360)) + center.dx,
            j / 5 * radius * sin(pi * 2 * (angleMul[(i + 1) % 6] * 30 / 360)) + center.dy,
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
