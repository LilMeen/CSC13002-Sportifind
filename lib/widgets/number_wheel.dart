import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NumberWheel extends StatefulWidget {

  const NumberWheel({super.key});

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  int _selectedValue = 0;

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
      onPressed: () => showCupertinoModalPopup(
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
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedValue,
                  ),
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
                      _selectedValue = value;
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
      ),
    );
  }
}
