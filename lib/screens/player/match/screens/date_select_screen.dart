import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/screens/select_stadium_screen.dart';
import 'package:sportifind/screens/player/match/util/booking_calendar.dart';
import 'package:sportifind/screens/player/match/widgets/field_picker.dart';
import 'package:sportifind/widgets/date_picker.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.selectedStadium,
      required this.selectedTeam,
      required this.numberOfField,
      required this.addMatchCard});

  final String selectedTeam;
  final String selectedStadium;
  final int numberOfField;
  final void Function(MatchCard matchcard) addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
  String selectedField = "1";
  List<MatchCard> userMatches = [];
  List<DateTimeRange> bookedSlot = [];
  String selectedPlayTime = '1h00';

  var playTime = [
    '1h00',
    '1h30',
    '2h00',
  ];

  List<DateTimeRange> generatePauseSlot(int selectedPlayTime) {
    if (selectedPlayTime == 60) {
      return [
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 22, 30),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      ];
    } else if (selectedPlayTime == 90) {
      return [
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 22, 00),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      ];
    } else if (selectedPlayTime == 120) {
      return [
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 21, 30),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      ];
    } else {
      return [];
    }
  }

  DateTime convertStringToDateTime(String timeString, String selectedDate) {
    final hourFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('M/D/yyyy');
    final time = hourFormat.parse(timeString);
    final date = dateFormat.parse(selectedDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
  Future<List<DateTimeRange>> getMatchDate(
      DateTime selectedDate, String selectedField) async {
    bookedSlot.clear();
    userMatches.clear();
    final String date = formatter.format(selectedDate);

    await getMatchData();
    for (var i = 0; i < userMatches.length; i++) {
      final String matchDate = userMatches[i].date;
      print(selectedField);
      print(userMatches[i].field);
      if (date == matchDate &&
          selectedField == userMatches[i].field &&
          widget.selectedStadium == userMatches[i].stadium) {
        bookedSlot.add(DateTimeRange(
            start: convertStringToDateTime(
                userMatches[i].start, userMatches[i].date),
            end: convertStringToDateTime(
                userMatches[i].end, userMatches[i].date)));
      }
    }
    userMatches.clear();
    return bookedSlot;
  }

  int convertDurationStringToInt(String durationString) {
    final parts = durationString.split('h');
    final hours = int.parse(parts[0]);
    final minutes =
        int.parse(parts.length > 1 ? parts[1].substring(0, 2) : '00');
    return hours * 60 + minutes;
  }

  void refreshByDate(DateTime pickedDate) async {
    bookedSlot = await getMatchDate(pickedDate, selectedField);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void refreshByField(String pickedField) async {
    bookedSlot = await getMatchDate(selectedDate!, pickedField);
    setState(() {
      selectedField = pickedField;
    });
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

  // Function to build booking Calendar
  Widget bookingCalender(double bookingHeight) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: bookingHeight,
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
              selectedField: selectedField,
              pauseSlots: generatePauseSlot(
                  convertDurationStringToInt(selectedPlayTime)),
              addMatchCard: widget.addMatchCard,
              bookedSlot: bookedSlot,
              bookingGridCrossAxisCount: width < 400 ? 3 : 4,
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
                  const SizedBox(
                    height: 40,
                  ),
                  FieldPicker(
                      func: refreshByField,
                      numberOfField: widget.numberOfField,
                      selectedField: selectedField,
                      height: 40,
                      width: 75),
                  const SizedBox(height: 40),
                  DatePicker(
                    func: refreshByDate,
                    height: 40,
                    width: 175,
                    selectedDate: selectedDate,
                  ),
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
