import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/profile/presentation/widgets/setting_dialog.dart'; 

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    super.key,
    required this.title,
    required this.endIcon,
    required this.textColor,
  });

  final String title;
  final bool endIcon;
  final Color? textColor;

  IconData getIcon(String title) {
    switch (title) {
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

  SettingDialogType getDialogType(String title) {
    switch (title) {
      case "Help & Feedback":
        return SettingDialogType.helpAndFeedback;
      case "Policy":
        return SettingDialogType.policy;
      case "About us":
        return SettingDialogType.aboutUs;
      default:
        return SettingDialogType.helpAndFeedback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SettingDialog(type: getDialogType(title));
          },
        );
      },
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.3),
        ),
        child: Icon(
          getIcon(title),
          color: SportifindTheme.bluePurple,
          size: title == 'Help & Feedback' ? 22 : 24,
        ),
      ),
      title: Text(
        title,
        style: SportifindTheme.normalTextBlack.copyWith(fontSize: 16),
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
