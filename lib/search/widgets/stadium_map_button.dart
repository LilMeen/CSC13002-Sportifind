import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class StadiumMapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StadiumMapButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.map_outlined),
      label: Text('Open stadium map', style: SportifindTheme.normalTextWhite),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: SportifindTheme.bluePurple,
        padding:
            const EdgeInsets.symmetric(vertical: 13),
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(30)),
        ),
      ),
    );
  }
}
