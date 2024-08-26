import 'package:flutter/material.dart';
import 'package:sportifind/features/profile/presentation/screens/stadium_owner_profile_screen.dart'; 
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/owner_stadium_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/schedule_screen.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_owner/statistic/statistic_screen.dart';

class StadiumOwnerHomeScreen extends StatefulWidget {
  static route () =>
      MaterialPageRoute(builder: (context) => const StadiumOwnerHomeScreen());
  const StadiumOwnerHomeScreen({super.key});

  @override
  State<StadiumOwnerHomeScreen> createState() {
    return _StadiumOwnerHomeScreenState();
  }
}

class _StadiumOwnerHomeScreenState extends State<StadiumOwnerHomeScreen> {

  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    StadiumStatisticScreen(),
    ScheduleScreen(),
    OwnerStadiumScreen(),
    StadiumOwnerProfileScreen(),
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
