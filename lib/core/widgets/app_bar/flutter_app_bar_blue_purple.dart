// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class FeatureAppBarBluePurple extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String size;

  const FeatureAppBarBluePurple(
      {super.key, required this.title, this.size = 'large'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: size == 'large'
            ? SportifindTheme.sportifindFeatureAppBarBluePurple
            : SportifindTheme.sportifindFeatureAppBarBluePurpleSmall,
      ),
      centerTitle: true,
      backgroundColor: SportifindTheme.backgroundColor,
      iconTheme: IconThemeData(color: SportifindTheme.bluePurple),
      elevation: 0,
      surfaceTintColor: SportifindTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
