import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'lib/assets/button_icon/tab_4.png',
      selectedImagePath: 'lib/assets/button_icon/tab_4s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'lib/assets/button_icon/tab_4.png',
      selectedImagePath: 'lib/assets/button_icon/tab_4s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'lib/assets/button_icon/tab_4.png',
      selectedImagePath: 'lib/assets/button_icon/tab_4s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'lib/assets/button_icon/tab_4.png',
      selectedImagePath: 'lib/assets/button_icon/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
