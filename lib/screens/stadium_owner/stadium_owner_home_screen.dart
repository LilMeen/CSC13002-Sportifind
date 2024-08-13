import 'package:flutter/material.dart';
import 'package:sportifind/screens/stadium_owner/schedule/schedule_screen.dart';
import 'package:sportifind/screens/stadium_owner/stadium/stadium_screen.dart';
import 'package:sportifind/screens/stadium_owner/statistic/statistic_screen.dart';

class StadiumOwnerHomeScreen extends StatefulWidget {
  const StadiumOwnerHomeScreen({super.key});

  @override
  State<StadiumOwnerHomeScreen> createState() {
    return _StadiumOwnerHomeScreenState();
  }
}

class _StadiumOwnerHomeScreenState extends State<StadiumOwnerHomeScreen> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    StadiumStatisticScreen(),
    ScheduleScreen(),
    Text(
      'Index 2: Home',
      style: optionStyle,
    ),
    OwnerStadiumScreen(),
    Text(
      'Index 4: Personal',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'       
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium_outlined),
            label: 'Stadium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
        ],
        unselectedItemColor: Colors.grey[600],  
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
