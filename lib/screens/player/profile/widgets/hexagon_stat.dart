import 'package:flutter/material.dart';
import 'dart:math';

class Rating {
  final String name;
  final int value;
  const Rating(this.name, this.value);
}

const messi = [
  Rating('PACE', 85),
  Rating('SHOOT', 89),
  Rating('PASS', 10),
  Rating('DRI', 89),
  Rating('DEF', 3),
  Rating('PHY', 89),
];

class Hexagon extends StatelessWidget {
  const Hexagon({super.key, required this.screenWidth});

  final double screenWidth;
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
            Labels(radius: radius, diameter: diameter, rating: messi),
            CustomPaint(painter: HexagonPainter(radius: radius)),
            ClipPath(
              clipper: HexagonClipper(
                radius: radius,
                multipliers: [
                  messi[0].value / 100,
                  messi[1].value / 100,
                  messi[2].value / 100,
                  messi[3].value / 100,
                  messi[4].value / 100,
                  messi[5].value / 100,
                ],
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
    super.key,
    required this.radius,
    required this.diameter,
    required this.rating,
  });

  final double radius, diameter;
  final List<Rating> rating;

  @override
  Widget build(BuildContext context) {
    final center = Offset(diameter / 2, diameter / 2);
    final style = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w600);
    const textAlign = TextAlign.center;
    return Stack(
      children: [
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 30 / 360) + center.dx,
              radius * sin(pi * 2 * 30 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[0].name, textAlign: textAlign, style: style),
                Text(rating[0].value.toString(),
                    textAlign: textAlign, style: style),
              ],
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 90 / 360) + center.dx,
              radius * sin(pi * 2 * 90 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[1].name, textAlign: textAlign, style: style),
                Text(rating[1].value.toString(),
                    textAlign: textAlign, style: style),
              ],
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 150 / 360) + center.dx,
              radius * sin(pi * 2 * 150 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[2].name, textAlign: textAlign, style: style),
                Text(rating[2].value.toString(),
                    textAlign: textAlign, style: style),
              ],
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 210 / 360) + center.dx,
              radius * sin(pi * 2 * 210 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[3].name, textAlign: textAlign, style: style),
                Text(rating[3].value.toString(),
                    textAlign: textAlign, style: style),
              ],
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 270 / 360) + center.dx,
              radius * sin(pi * 2 * 270 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[4].name, textAlign: textAlign, style: style),
                Text(rating[4].value.toString(),
                    textAlign: textAlign, style: style),
              ],
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 330 / 360) + center.dx,
              radius * sin(pi * 2 * 330 / 360) + center.dy,
            ),
            width: 100,
            height: 50,
          ),
          child: Center(
            child: Column(
              children: [
                Text(rating[5].name, textAlign: textAlign, style: style),
                Text(rating[5].value.toString(),
                    textAlign: textAlign, style: style),
              ],
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