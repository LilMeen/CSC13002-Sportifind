import 'package:flutter/material.dart';

class FootPicker extends StatefulWidget {
  FootPicker({required this.controller, super.key});
    final TextEditingController controller;
  @override
  _FootPickerState createState() => _FootPickerState();
}

class _FootPickerState extends State<FootPicker> {
  bool isLeftPicked = false;
  bool isRightPicked = false;

  @override
  void initState() {
    super.initState();
    _initializePickerState();
  }

  Future<void> _initializePickerState() async {
    await Future.delayed(Duration(seconds: 1));
    String kkk = widget.controller.text;
    print('hehe $kkk');
    if (widget.controller.text == '1') {
      setState(() {
        isRightPicked = true;
        isLeftPicked = false;
      });
    } else if (widget.controller.text == '0') {
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
      widget.controller.text = '0';
    } else if (isRightPicked) {
      widget.controller.text = '1';
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
