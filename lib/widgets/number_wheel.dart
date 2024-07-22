import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NumberWheel extends StatefulWidget {
  const NumberWheel({super.key});

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  int _selectedValue = 80;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: _selectedValue);
    print("ScrollController initialized with initialItem: ${_scrollController.initialItem}");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      onPressed: () {
        print("Button pressed, showing CupertinoPicker with initial value $_selectedValue");
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
                      print("Item changed to $value");
                      setState(() {
                        _selectedValue = value;
                        print("State updated, _selectedValue: $_selectedValue");
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: NumberWheel(),
      ),
    ),
  ));
}
