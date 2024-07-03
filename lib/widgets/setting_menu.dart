import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    super.key,
    required this.title,
    required this.onPress,
    required this.endIcon,
    required this.textColor,
  });

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
        child: const Icon(
          Icons.settings,
          color: Colors.tealAccent,
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
              width: 30,
              height: 30,
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

