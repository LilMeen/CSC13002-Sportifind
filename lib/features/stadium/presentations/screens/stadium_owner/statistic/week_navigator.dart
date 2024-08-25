import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

class WeekNavigator extends StatefulWidget {
  final int selectedWeek; 
  final ValueChanged<int> onWeekNumberChanged; 

  const WeekNavigator({
    super.key,
    required this.selectedWeek,
    required this.onWeekNumberChanged,
  });

  @override
  WeekNavigatorState createState() => WeekNavigatorState();
}

class WeekNavigatorState extends State<WeekNavigator> {
  late int selectedWeekOffset;

  @override
  void initState() {
    super.initState();
    selectedWeekOffset = 0;
  }

  DateTime get currentDate => DateTime.now();

  int getWeekOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  void _previousWeek() {
    setState(() {
      if (selectedWeekOffset > -1) {
        selectedWeekOffset--;
        _notifyWeekNumberChange();
      }
    });
  }

  void _nextWeek() {
    setState(() {
      if (selectedWeekOffset < 0) {
        selectedWeekOffset++;
        _notifyWeekNumberChange(); 
      }
    });
  }

  void _notifyWeekNumberChange() {
    DateTime selectedDate = currentDate.add(Duration(days: 7 * selectedWeekOffset));
    int selectedWeekNumber = getWeekOfYear(selectedDate);
    widget.onWeekNumberChanged(selectedWeekNumber); 
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = currentDate.add(Duration(days: 7 * selectedWeekOffset));
    DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: selectedWeekOffset > -1 ? _previousWeek : null,
          color: selectedWeekOffset > -1 ? Colors.black : Colors.grey,
        ),
        Text(
          "${DateFormat('dd/MM').format(startOfWeek)} - ${DateFormat('dd/MM').format(endOfWeek)}",
          style: SportifindTheme.titleDeleteStadium,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: selectedWeekOffset < 0 ? _nextWeek : null,
          color: selectedWeekOffset < 0 ? Colors.black : Colors.grey,
        ),
      ],
    );
  }
}
