import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class NumberWheel extends StatefulWidget {
  final Function(int) onSaved;
  final int stat;

  const NumberWheel({super.key, required this.onSaved, required this.stat});

  @override
  State<NumberWheel> createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  late int _selectedValue;
  late int _tempValue;
  late FixedExtentScrollController _scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.delayed(const Duration(seconds: 2));

    _selectedValue = widget.stat;
    _tempValue = _selectedValue;

    _scrollController = FixedExtentScrollController(initialItem: _selectedValue == 0 ? 80 : _selectedValue);

    setState(() {
      _isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: SportifindTheme.bluePurple));
    }
    
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: SportifindTheme.bluePurple,
      borderRadius: BorderRadius.circular(30),
      child: Text(
        '$_selectedValue',  
        style: SportifindTheme.normalTextWhite
      ),
      onPressed: () => _showPicker(context),
    );
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
                      style: SportifindTheme.normalTextBlack,
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
              child: Text('Done', style: SportifindTheme.normalTextBlack),
              onPressed: () {
                setState(() {
                  _selectedValue = _tempValue;
                  _scrollController = FixedExtentScrollController(initialItem: _selectedValue);
                  widget.onSaved(_selectedValue == 80 && widget.stat == 0 ? 0 : _selectedValue);
                });
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}