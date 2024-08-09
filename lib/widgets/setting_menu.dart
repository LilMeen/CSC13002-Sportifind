import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    super.key,
    required this.title,
    required this.onPress,
    required this.endIcon,
    required this.textColor,
  });

  IconData getIcon(String title){
    switch(title){
      case "Help & Feedback":
        return Icons.feedback_rounded;
      case "Policy":
        return Icons.policy_rounded;
      case "About us":
        return Icons.info_rounded;
      default:
        return Icons.settings;
    }
  }

  final String title;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Icon(
          getIcon(title),
          color: Color.fromARGB(255, 24, 24, 207),
          size: title == 'Help & Feedback' ? 22 : 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}

