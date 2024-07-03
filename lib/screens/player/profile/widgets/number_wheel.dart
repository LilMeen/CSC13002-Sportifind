import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NumberWheel extends StatefulWidget {
  final Function(int) onSaved;

  const NumberWheel({super.key, required this.onSaved});

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  int _selectedValue = 0;
  int _tempValue = 0;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedValue);
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
      color: Colors.tealAccent,
      borderRadius: BorderRadius.circular(30),
      child: Text(
        '$_selectedValue',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => _showPicker(context),
    );
  }
}
