import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final int percentage;
  final VoidCallback onPressed;
  final bool isUp;

  const StatisticCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.title,
    required this.percentage,
    required this.onPressed,
    required this.isUp,
  }) : super(key: key);

  Text trend(bool isUp){
    if (isUp == true){
      return Text(
        '+$percentage%',
        style: const TextStyle(
        fontSize: 12,
        color: Colors.green,
        fontWeight: FontWeight.bold,
        ),
      );
    }
    else {
      return Text(
        '-$percentage%',
        style: const TextStyle(
        fontSize: 12,
        color: Colors.red,
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
          side: const BorderSide(color: Color.fromARGB(255, 214, 214, 214), width: 1), // Stroke border
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              trend(isUp),
            ],
          ),
        ),
      ),
    );
  }
}
