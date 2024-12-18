import 'package:flutter/material.dart';

class FootPicker extends StatefulWidget {
  const FootPicker({required this.controller, super.key});
    final TextEditingController controller;
  @override
  FootPickerState createState() => FootPickerState();
}

class FootPickerState extends State<FootPicker> {
  bool isLeftPicked = false;
  bool isRightPicked = false;

  @override
  void initState() {
    super.initState();
    _initializePickerState();
  }

  void _initializePickerState() {
    if (widget.controller.text == 'right') {
      setState(() {
        isRightPicked = true;
        isLeftPicked = false;
      });
    } else if (widget.controller.text == 'left') {
      setState(() {
        isLeftPicked = true;
        isRightPicked = false;
      });
    }
    else {
      isLeftPicked = false;
      isRightPicked = false;
    }
  }

  void _updateController() {
    if (isLeftPicked) {
      widget.controller.text = 'left';
    } else if (isRightPicked) {
      widget.controller.text = 'right';
    } else {
      widget.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLeftPicked = !isLeftPicked;
                isRightPicked = false;
                _updateController();
              });
            },
            child: Image.asset(
              isLeftPicked ? 'lib/assets/left_picked.png' : 'lib/assets/left_unpicked.png',
              width: 50,
              height: 50,
            ),
          ),
          //SizedBox(width: 5), 
          GestureDetector(
            onTap: () {
              setState(() {
                isRightPicked = !isRightPicked;
                isLeftPicked = false;
                _updateController();
              });
            },
            child: Image.asset(
              isRightPicked ? 'lib/assets/right_picked.png' : 'lib/assets/right_unpicked.png',
              width: 50,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
