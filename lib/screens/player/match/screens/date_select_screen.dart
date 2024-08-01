import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/util/booking_calendar.dart';
import 'package:sportifind/screens/player/match/widgets/field_picker.dart';
import 'package:sportifind/widgets/date_picker.dart';
import 'package:sportifind/services/match_service.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.selectedStadiumId,
      required this.selectedStadiumName,
      required this.selectedTeam,
      required this.numberOfField,
      required this.addMatchCard});

  final String selectedTeam;
  final String selectedStadiumId;
  final String selectedStadiumName;
  final int numberOfField;
  final void Function(MatchCard matchcard)? addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
  String selectedField = "1";
  List<MatchCard> userMatches = [];
  List<DateTimeRange> bookedSlot = [];
  String selectedPlayTime = '1h00';
  MatchService matchService = MatchService();

  var playTime = [
    '1h00',
    '1h30',
    '2h00',
  ];

  List<DateTimeRange> generatePauseSlot(int selectedPlayTime) {
    List<DateTimeRange> pauseSlot = [];
    if (selectedPlayTime == 60) {
      pauseSlot.add(
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 22, 30),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      );
    } else if (selectedPlayTime == 90) {
      pauseSlot.add(
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 22, 00),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      );
    } else if (selectedPlayTime == 120) {
      pauseSlot.add(
        DateTimeRange(
          start: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 21, 30),
          end: DateTime(selectedDate!.year, selectedDate!.month,
              selectedDate!.day, 23, 00),
        ),
      );
    } else {
      return pauseSlot;
    }
    return pauseSlot;
  }

  int convertDurationStringToInt(String durationString) {
    final parts = durationString.split('h');
    final hours = int.parse(parts[0]);
    final minutes =
        int.parse(parts.length > 1 ? parts[1].substring(0, 2) : '00');
    return hours * 60 + minutes;
  }

  void refreshByDate(DateTime pickedDate) async {
    await matchService.getMatchDate(pickedDate, selectedField,
        widget.selectedStadiumId, userMatches, bookedSlot);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void refreshByField(String pickedField) async {
    await matchService.getMatchDate(selectedDate!, pickedField,
        widget.selectedStadiumId, userMatches, bookedSlot);
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
            color: SportifindTheme.grey,
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
              selectedStadium: widget.selectedStadiumId,
              selectedTeam: widget.selectedTeam,
              selectedDate: selectedDate!,
              selectedField: selectedField,
              pauseSlots: generatePauseSlot(
                  convertDurationStringToInt(selectedPlayTime)),
              addMatchCard: widget.addMatchCard!,
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
            color: SportifindTheme.grey,
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
    final String selectedStadium = widget.selectedStadiumName;
    final String selectedTeam = widget.selectedTeam;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SportifindTheme.background,
            leading: BackButton(
              color: SportifindTheme.grey,
              onPressed: () {
                Navigator.pop(
                  context,
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
