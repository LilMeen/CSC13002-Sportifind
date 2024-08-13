import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekNavigator extends StatefulWidget {
  final int selectedWeek; 
  final ValueChanged<int> onWeekNumberChanged; 

  WeekNavigator({
    Key? key,
    required this.selectedWeek,
    required this.onWeekNumberChanged,
  }) : super(key: key);

  @override
  _WeekNavigatorState createState() => _WeekNavigatorState();
}

class _WeekNavigatorState extends State<WeekNavigator> {
  late int selectedWeekOffset;

  @override
  void initState() {
    super.initState();
    selectedWeekOffset = 0;
    print('Initial Selected Week Offset: $selectedWeekOffset'); 
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
        print('Week Offset After Previous: $selectedWeekOffset');
      }
    });
  }

  void _nextWeek() {
    setState(() {
      if (selectedWeekOffset < 0) {
        selectedWeekOffset++;
        _notifyWeekNumberChange(); 
        print('Week Offset After Next: $selectedWeekOffset'); 
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
    print(selectedWeekOffset);
    DateTime selectedDate = currentDate.add(Duration(days: 7 * selectedWeekOffset));
    print(selectedDate);
    DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    int selectedWeekNumber = getWeekOfYear(selectedDate);

    print('Selected Week Number: $selectedWeekNumber'); // Debugging statement

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: selectedWeekOffset > -1 ? _previousWeek : null,
          color: selectedWeekOffset > -1 ? Colors.black : Colors.grey,
        ),
        Text(
          "${DateFormat('dd/MM').format(startOfWeek)} - ${DateFormat('dd/MM').format(endOfWeek)}",
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: selectedWeekOffset < 0 ? _nextWeek : null,
          color: selectedWeekOffset < 0 ? Colors.black : Colors.grey,
        ),
      ],
    );
  }
}
