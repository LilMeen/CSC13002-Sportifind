import 'package:flutter/material.dart';
import 'package:sportifind/models/field_data.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/screens/player/match/util/booking_calendar.dart';
import 'package:sportifind/screens/player/match/widgets/field_picker.dart';
import 'package:sportifind/widgets/date_picker.dart';
import 'package:sportifind/util/match_service.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.selectedStadiumId,
      required this.selectedStadiumName,
      required this.selectedStadiumOwner,
      required this.selectedTeamId,
      required this.selectedTeamName,
      required this.selectedTeamAvatar,
      required this.fields,
      required this.addMatchCard});

  final String selectedTeamId;
  final String selectedTeamName;
  final String selectedTeamAvatar;
  final String selectedStadiumId;
  final String selectedStadiumName;
  final String selectedStadiumOwner;
  final List<FieldData> fields;
  final void Function(MatchCard matchcard)? addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

int selectedField = 1;

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
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

  void refreshByField(int pickedField) async {
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
        Text(
          "Duration",
          style: SportifindTheme.dropdown,
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
              selectedStadiumOwner: widget.selectedStadiumOwner,
              selectedTeam: widget.selectedTeamId,
              selectedTeamAvatar: widget.selectedTeamAvatar,
              selectedDate: selectedDate!,
              selectedField: selectedField,
              pauseSlots: generatePauseSlot(
                  convertDurationStringToInt(selectedPlayTime)),
              addMatchCard: widget.addMatchCard!,
              bookedSlot: bookedSlot,
              wholeDayIsBookedWidget:
                  const Text('Sorry, for this day everything is booked'),
            )
          : Text(
              "Please choose a date to continue",
              style: SportifindTheme.dropdown,
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
          style: SportifindTheme.dropdown,
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
                  style: SportifindTheme.dropdown,
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
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SportifindTheme.whiteSmoke,
            leading: BackButton(
              color: SportifindTheme.grey,
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            centerTitle: true,
            title: Text(
              "Create match",
              style: SportifindTheme.dropdown,
            ),
          ),
          backgroundColor: SportifindTheme.whiteSmoke,
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
                    widget.selectedTeamName,
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
                      fields: widget.fields,
                      selectedField: selectedField,
                      height: 40,
                      width: 125),
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
