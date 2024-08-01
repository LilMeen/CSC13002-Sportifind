import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class SportifindAppBar extends StatelessWidget {
  const SportifindAppBar({super.key, required this.title});
  final String title; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 0.27,
                    color: SportifindTheme.nearlyBlack,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            child: Image.asset('lib/assets/logo/logo.png'),
          )
        ],
      ),
    );
  }
}
