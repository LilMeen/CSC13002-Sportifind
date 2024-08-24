import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class InformationMenu extends StatelessWidget {
  const InformationMenu(
      {super.key, required this.textContent, required this.icon});
  final String textContent;
  final String icon;

  Widget getIcon(String icon) {
    switch (icon) {
      case "phone":
        return Icon(
          Icons.local_phone,
          color: SportifindTheme.bluePurple,
        );
      case "location":
        return Icon(
          Icons.location_on_rounded,
          color: SportifindTheme.bluePurple,
        );
      case "dob":
        return Icon(
          Icons.calendar_month_rounded,
          color: SportifindTheme.bluePurple,
        );
      case "height":
        return Image.asset(
          'lib/assets/height.png',
          width: 24,
          height: 24,
        );
      case "weight":
        return Image.asset(
          'lib/assets/weight.png',
          width: 24,
          height: 24,
        );
      case "foot":
        // Handle foot with custom images
        return Image.asset(
          textContent == 'Right footed'
              ? 'lib/assets/right.png'
              : textContent == 'Left footed'
                  ? 'lib/assets/left.png'
                  : 'lib/assets/sole.png',
          width: 24,
          height: 24,
        );
      default:
        return Icon(
          Icons.home,
          color: SportifindTheme.bluePurple,
        ); // Default icon if no match is found
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
            child: getIcon(icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              textContent,
              style: SportifindTheme.normalTextBlack.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
