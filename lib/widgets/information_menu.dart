import 'package:flutter/material.dart';

class InformationMenu extends StatelessWidget {
  const InformationMenu(
      {super.key, required this.textContent, required this.icon});
  final String textContent;
  final String icon;

  IconData getIcon(String icon) {
    switch (icon) {
      case "phone":
        return Icons.local_phone;
      case "location":
        return Icons.location_on_rounded;
      case "dob":
        return Icons.calendar_month_rounded;
      case "height":
        return Icons.create_outlined;
      case "weight":
        return Icons.create_outlined;
      case "foot":
        return Icons.create_outlined;
      default:
        return Icons.home; // Default icon if no match is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Icon(
              getIcon(icon),
              color: Color.fromARGB(255, 24, 24, 207),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              textContent,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


