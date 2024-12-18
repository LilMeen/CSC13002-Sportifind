import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class NumberWheel extends StatefulWidget {
  final Function(int) onSaved;
  final int initValue;

  const NumberWheel({super.key, 
    required this.onSaved,
    required this.initValue
  });

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  int _selectedValue = 0;
  int _tempValue = 80;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: widget.initValue != 0 ? widget.initValue : 80);
    _selectedValue = widget.initValue;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 40,
                scrollController: _scrollController,
                children: List<Widget>.generate(101, (int index) {
                  return Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }),
                onSelectedItemChanged: (int value) {
                  setState(() {
                    _tempValue = value;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() {
                  _selectedValue = _tempValue;
                  _scrollController = FixedExtentScrollController(initialItem: _selectedValue);
                });
                widget.onSaved(_selectedValue);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: SportifindTheme.bluePurple,
      borderRadius: BorderRadius.circular(30),
      child: Text(
        '$_selectedValue',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => _showPicker(context),
    );
  }
}