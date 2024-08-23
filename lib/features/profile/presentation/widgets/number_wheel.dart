import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    // Giả lập thời gian chờ đợi dữ liệu (hoặc thay bằng hàm fetch dữ liệu thực tế)
    await Future.delayed(Duration(seconds: 2));

    // Lưu giá trị đã được fetch (sử dụng widget.stat)
    _selectedValue = widget.stat;
    _tempValue = _selectedValue;

    print('Initial stat value: $_selectedValue');

    // Khởi tạo FixedExtentScrollController
    _scrollController = FixedExtentScrollController(initialItem: _selectedValue == 0 ? 80 : _selectedValue);

    setState(() {
      _isLoading = false; // Dữ liệu đã sẵn sàng
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.tealAccent,
      borderRadius: BorderRadius.circular(30),
      child: Text(
        // Hiển thị giá trị đã được fetch (_selectedValue)
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

                  // Lưu giá trị được chọn vào onSaved (giữ nguyên nếu không phải 80)
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
