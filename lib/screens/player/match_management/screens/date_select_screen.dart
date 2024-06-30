import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match_management/screens/select_stadium_screen.dart';
import 'package:sportifind/screens/player/match_management/util/booking_calendar.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.selectedStadium,
      required this.selectedTeam,
      required this.addMatchCard});

  final String selectedTeam;
  final String selectedStadium;
  final void Function(MatchCard matchcard) addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
  List<MatchCard> userMatches = [];
  List<DateTimeRange> bookedSlot = [];
  String selectedPlayTime = '1h00';

  var playTime = [
    '1h00',
    '1h30',
    '2h00',
  ];

  int convertDurationStringToInt(String durationString) {
    final parts = durationString.split('h');
    final hours = int.parse(parts[0]);
    final minutes =
        int.parse(parts.length > 1 ? parts[1].substring(0, 2) : '00');
    return hours * 60 + minutes;
  }

  DateTime convertStringToDateTime(String timeString, DateTime selectedDate) {
    final dateFormat = DateFormat('HH:mm');
    final time = dateFormat.parse(timeString);
    return DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        time.hour, time.minute);
  }

  // Function for fetching data from firestore  
  Future<void> getMatchData() async {
    final matchesQuery =
        await FirebaseFirestore.instance.collection('matches').get();
    final matches = matchesQuery.docs
        .map((match) => MatchCard.fromSnapshot(match))
        .toList();
    for (var i = 0; i < matches.length; ++i) {
      userMatches.add(matches[i]);
    }
  }

  // Function for parsing data
  Future<List<DateTimeRange>> getMatchDate(DateTime selectedDate) async {
    bookedSlot.clear();
    userMatches.clear();
    final formatter = DateFormat.yMd();
    final String date = formatter.format(selectedDate);

    await getMatchData();
    for (var i = 0; i < userMatches.length; i++) {
      final String matchDate = formatter.format(userMatches[i].date);
      if (date == matchDate) {
        bookedSlot.add(DateTimeRange(
            start: convertStringToDateTime(
                userMatches[i].startHour, userMatches[i].date),
            end: convertStringToDateTime(
                userMatches[i].endHour, userMatches[i].date)));
      }
    }
    userMatches.clear();
    return bookedSlot;
  }

  // Function to build duration dropdown button
  Widget durationPicker(double height, double width) {
    return Row(
      children: [
        const Text(
          "Duration",
          style: SportifindTheme.display2,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: SportifindTheme.nearlyGreen,
          ),
          child: DropdownButton(
            borderRadius: BorderRadius.circular(5.0),
            value: selectedPlayTime,
            isExpanded: true,
            items: playTime.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                selectedPlayTime = value;
              });
            },
          ),
        ),
      ],
    );
  }

  // Function to show Date picker
  void _showDatePicker(List<DateTimeRange> bookedSlot) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 25),
    );
    if (pickedDate != null) {
      bookedSlot = await getMatchDate(pickedDate);
      print('Booked Date: $bookedSlot');
      setState(() {
        selectedDate = pickedDate;
        print('Selected Date: $selectedDate');
      });
    }
  }

  // Function to build date picker
  Widget datePicker(double height, double width) {
    return Row(
      children: [
        const Text(
          "Date",
          style: SportifindTheme.display2,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: SportifindTheme.nearlyGreen,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                selectedDate == null
                    ? 'Selected Date'
                    : formatter.format(selectedDate!),
                style: SportifindTheme.status,
              ),
              IconButton(
                onPressed: () {
                  _showDatePicker(bookedSlot);
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to build booking Calendar
  Widget bookingCalender(double height) {
    return SizedBox(
      height: height,
      child: selectedDate != null
          ? BookingCalendar(
              bookingService: BookingService(
                serviceName: 'Mock Service',
                serviceDuration: 30,
                bookingEnd: DateTime(selectedDate!.year, selectedDate!.month,
                    selectedDate!.day, 23, 0),
                bookingStart: DateTime(selectedDate!.year, selectedDate!.month,
                    selectedDate!.day, 8, 0),
              ),
              hideBreakTime: false,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'en',
              selectedPlayTime: convertDurationStringToInt(selectedPlayTime),
              selectedStadium: widget.selectedStadium,
              selectedTeam: widget.selectedTeam,
              selectedDate: selectedDate!,
              addMatchCard: widget.addMatchCard,
              bookedSlot: bookedSlot,
              wholeDayIsBookedWidget:
                  const Text('Sorry, for this day everything is booked'),
            )
          : const Text(
              "Please choose a date to continue",
              style: SportifindTheme.display2,
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget displayBox(String title, String displayItem, String avatar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SportifindTheme.display2,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: SportifindTheme.nearlyGreen,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(avatar, width: 25),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  displayItem,
                  style: SportifindTheme.title,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedStadium = widget.selectedStadium;
    final String selectedTeam = widget.selectedTeam;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SportifindTheme.background,
            leading: BackButton(
              color: SportifindTheme.nearlyGreen,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectStadiumScreen(
                      addMatchCard: widget.addMatchCard,
                    ),
                  ),
                );
              },
            ),
            centerTitle: true,
            title: const Text(
              "Create match",
              style: SportifindTheme.display1,
            ),
          ),
          backgroundColor: SportifindTheme.background,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayBox(
                    "Tean",
                    selectedTeam,
                    "lib/assets/logo/logo.png",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  displayBox(
                    "Stadium",
                    selectedStadium,
                    "lib/assets/logo/logo.png",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  durationPicker(40, 75),
                  const SizedBox(height: 40),
                  datePicker(40, 175),
                  const SizedBox(height: 40),
                  bookingCalender(650),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
