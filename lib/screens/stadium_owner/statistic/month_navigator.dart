import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/sportifind_theme.dart';

class MonthNavigator extends StatefulWidget {
  final int selectedMonth; 
  final ValueChanged<int> onMonthNumberChanged;

  MonthNavigator({
    Key? key,
    required this.selectedMonth,
    required this.onMonthNumberChanged,
  }) : super(key: key);


  @override
  _MonthNavigatorState createState() => _MonthNavigatorState();
}

class _MonthNavigatorState extends State<MonthNavigator> {
  late int selectedMonthOffset;

  @override
  void initState() {
    super.initState();
    selectedMonthOffset = 0;
    print('Initial Selected Month Offset: $selectedMonthOffset'); 
  }

  DateTime get currentDate => DateTime.now();

  int getMonthOfYear(DateTime date) {
    return date.month;
  }

  void _previousMonth() {
  setState(() {
    if (selectedMonthOffset > -1) {
      selectedMonthOffset--;
      _notifyMonthNumberChange();
    }
  });
}

void _nextMonth() {
  setState(() {
    if (selectedMonthOffset < 0) {
      selectedMonthOffset++;
      _notifyMonthNumberChange();
    }
  });
}

  void _notifyMonthNumberChange() {
  DateTime newDate = DateTime(currentDate.year, currentDate.month + selectedMonthOffset, 1);
  int newMonth = newDate.month;
  if (newMonth > 12) {
    newMonth = newMonth % 12;
  } else if (newMonth < 1) {
    newMonth = 12 + newMonth;
  }
  widget.onMonthNumberChanged(newMonth);
}

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime(currentDate.year, currentDate.month + selectedMonthOffset, 1);
    DateTime nextMonthDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    int selectedMonthNumber = getMonthOfYear(selectedDate);

    print('Selected Month Number: $selectedMonthNumber');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: selectedMonthOffset > -1 ? _previousMonth : null,
          color: selectedMonthOffset > -1 ? Colors.black : Colors.grey,
        ),
        Text(
          "${DateFormat('MM/yyyy').format(selectedDate)} - ${DateFormat('MM/yyyy').format(nextMonthDate)}",
          style: SportifindTheme.titleDeletStadium,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: selectedMonthOffset < 0 ? _nextMonth : null,
          color: selectedMonthOffset < 0 ? Colors.black : Colors.grey,
        ),
      ],
    );
  }
}
