import 'package:flutter/material.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/adapter/hex_color.dart';

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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
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
                        child: Form(
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: SportifindTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: SportifindTheme.nearlyDarkGreen,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Search for teams',
                              border: InputBorder.none,
                              helperStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: HexColor('#B9BABC'),
                              ),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: HexColor('#B9BABC'),
                              ),
                            ),
                            onEditingComplete: () {},
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
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}
