import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final double? percentage;
  final VoidCallback onPressed;
  final int? stadiumMatches;
  final int? totalMatches;
  final int status;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
    required this.onPressed,
    this.percentage,
    this.stadiumMatches,
    this.totalMatches,
    required this.status,
  });

  Widget buildExtraInformation() {
    if (status == 0) {
      return trend();
    } else if (status == 1) {
      return totalMatchesTrend();
    } else {
      return matchBooked();
    }
  }

  Text totalMatchesTrend() {
    int changeTotalMatches = totalMatches!;
    String sign = changeTotalMatches >= 0 ? '+' : '-';
    Color color = changeTotalMatches >= 0 ? Colors.green : Colors.red;

    return Text(
      '$sign${changeTotalMatches.abs()} Matches',
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text matchBooked() {
    return Text(
      "$stadiumMatches Matches",
      style: const TextStyle(
        fontSize: 12,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text trend() {
    double changePercentage = percentage!;
    String sign = changePercentage >= 0 ? '+' : '-';
    Color color = changePercentage >= 0 ? Colors.green : Colors.red;

    return Text(
      '$sign${changePercentage.abs().toStringAsFixed(2)}%',
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: SportifindTheme.backgroundColor,
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          width: 152,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                child: Icon(
                  icon,
                  color: SportifindTheme.bluePurple,
                  size: 26,
                ),
              ),
              const SizedBox(height: 2),
              Text(title, style: SportifindTheme.normalTextBlack),
              Text(
                value,
                style: SportifindTheme.normalTextBlack.copyWith(fontSize: 20),
              ),
              buildExtraInformation(),
            ],
          ),
        ),
      ),
    );
  }
}
