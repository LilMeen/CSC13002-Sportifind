import 'package:flutter/material.dart';
import 'package:navigation_view/item_navigation_view.dart';
import 'package:navigation_view/navigation_view.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class AppBBN extends StatelessWidget {
  const AppBBN({
    super.key,
    required this.onChangeScreen,
  });
  final ValueChanged<int> onChangeScreen;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return NavigationView(
      borderRadius: BorderRadius.circular(30),
      onChangePage: onChangeScreen,
      curve: Curves.fastEaseInToSlowEaseOut,
      durationAnimation: const Duration(milliseconds: 400),
      backgroundColor: Colors.white,
      borderTopColor: Colors.grey[300],
      color: SportifindTheme.bluePurple,
      items: [
        ItemNavigationView(
          childAfter: Icon(
            Icons.person,
            color: SportifindTheme.bluePurple,
            size: 35,
          ),
          childBefore: Icon(
            Icons.person_outlined,
            color: theme.dialogBackgroundColor
                .withBlue(230)
                .withAlpha(255)
                .withRed(150)
                .withGreen(150),
            size: 30,
          ),
        ),
        ItemNavigationView(
          childAfter: Icon(
            Icons.group,
            color: SportifindTheme.bluePurple,
            size: 35,
          ),
          childBefore: Icon(
            Icons.group_outlined,
            color: theme.dialogBackgroundColor
                .withBlue(230)
                .withAlpha(255)
                .withRed(150)
                .withGreen(150),
            size: 30,
          ),
        ),
        ItemNavigationView(
          childAfter: Icon(
            Icons.stadium,
            color: SportifindTheme.bluePurple,
            size: 35,
          ),
          childBefore: Icon(
            Icons.stadium_outlined,
            color: theme.dialogBackgroundColor
                .withBlue(230)
                .withAlpha(255)
                .withRed(150)
                .withGreen(150),
            size: 30,
          ),
        ),
        ItemNavigationView(
          childAfter: Icon(
            Icons.home,
            color: SportifindTheme.bluePurple,
            size: 35,
          ),
          childBefore: Icon(
            Icons.home_outlined,
            color: theme.dialogBackgroundColor
                .withBlue(230)
                .withAlpha(255)
                .withRed(150)
                .withGreen(150),
            size: 30,
          ),
        ),
      ],
    );
  }
}
