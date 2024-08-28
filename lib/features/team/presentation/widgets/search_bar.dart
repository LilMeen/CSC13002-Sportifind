import 'package:flutter/material.dart';
import 'package:sportifind/adapter/hex_color.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/features/team/presentation/screens/team_search_screen.dart';

class SportifindSearchBar extends StatelessWidget {
  const SportifindSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigate to the desired screen when the search bar is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamSearchScreen(),
                ),
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 64,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#F8FAFB'),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(13.0),
                      bottomLeft: Radius.circular(13.0),
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child:  Text(
                            'Search for team',
                            style: SportifindTheme.normalTextBlack.copyWith(
                            color: Colors.grey, 
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.search, color: HexColor('#B9BABC')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}
