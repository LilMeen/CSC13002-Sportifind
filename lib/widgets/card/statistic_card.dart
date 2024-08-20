import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/sportifind_theme.dart'; 

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final double percentage;
  final VoidCallback onPressed;
  final bool isText;

  const StatisticCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.title,
    required this.percentage,
    required this.onPressed,
    required this.isText,
  }) : super(key: key);

  Text trend() {
    if (isText) {
      try {
        DateTime date = DateFormat('dd/MM').parse(value);
        String dayOfWeek = DateFormat('E').format(date); 
        return Text(
          dayOfWeek,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        );
      } catch (e) {
        return const Text(
          'Invalid date',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    } else {
    double changePercentage = percentage;
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
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 227, 227, 227),
                child: Icon(
                  icon,
                  color: SportifindTheme.bluePurple,
                  size: 26,
                ),
              ), 
              const SizedBox(height: 2),          
              Text(
                title,
                style: SportifindTheme.normalTextBlack
              ),
              Text(
                value,
                style: SportifindTheme.normalTextBlack.copyWith(fontSize: 20),
              ),
              trend(),
            ],
          ),
        ),
      ),
    );
  }
}
