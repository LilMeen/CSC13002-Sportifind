import 'package:flutter/material.dart';
import 'package:sportifind/models/field_data.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/models/sportifind_theme.dart';
import 'package:sportifind/models/stadium_data.dart';
import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/match/util/booking_calendar.dart';
import 'package:sportifind/screens/player/match/widgets/field_picker.dart';
import 'package:sportifind/util/stadium_service.dart';
import 'package:sportifind/widgets/date_picker.dart';
import 'package:sportifind/util/match_service.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen(
      {super.key,
      required this.stadiumData,
      required this.selectedTeamAvatar,
      required this.selectedTeamName,
      required this.selectedTeamId,
      required this.addMatchCard});

  final StadiumData stadiumData;
  final String selectedTeamId;
  final String selectedTeamName;
  final String selectedTeamAvatar;
  final void Function(MatchCard matchcard)? addMatchCard;
  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
  List<MatchCard> userMatches = [];
  List<DateTimeRange> bookedSlot = [];
  String selectedPlayTime = '1h00';
  String selectedFieldType = '5-Player';
  MatchService matchService = MatchService();
  int selectedField = 1;
  List<String> typeOfField = [];

  var playTime = [
    '1h00',
    '1h30',
    '2h00',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFieldType(widget.stadiumData.fields);
  }

  List<String> getFieldType(List<FieldData> fields) {
    if (widget.stadiumData.getNumberOfTypeField('5-Player') != 0) {
      typeOfField.add('5-Player');
    }

    if (widget.stadiumData.getNumberOfTypeField('7-Player') != 0) {
      typeOfField.add('7-Player');
    }
    if (widget.stadiumData.getNumberOfTypeField('11-Player') != 0) {
      typeOfField.add('11-Player');
    }
    return typeOfField;
  }

  List<DateTimeRange> generatePauseSlot(int selectedPlayTime) {
    List<DateTimeRange> pauseSlot = [];
    if (selectedPlayTime == 60) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 30),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime)),
        ),
      );
    } else if (selectedPlayTime == 90) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 60),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime)),
        ),
      );
    } else if (selectedPlayTime == 120) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 90),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime)),
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
        widget.stadiumData.id, userMatches, bookedSlot);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void refreshByField(int pickedField) async {
    await matchService.getMatchDate(selectedDate!, pickedField,
        widget.stadiumData.id, userMatches, bookedSlot);
    setState(() {
      selectedField = pickedField;
    });
  }

  int convertTimeStringToMinutes(String timeString) {
    // Split the string by the colon
    List<String> parts = timeString.split(':');

    // Parse the hour and minute from the string
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Convert the hour into minutes and add the minutes
    int totalMinutes = hour * 60 + minute;

    return totalMinutes;
  }

  DateTime convertMinutesToDateTime(int totalMinutes) {
    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateTime object by adding the total minutes to the start of the day
    DateTime dateTime = DateTime(now.year, now.month, now.day)
        .add(Duration(minutes: totalMinutes));

    return dateTime;
  }

  // Function to build duration dropdown button
  Widget durationPicker(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Duration",
          style: SportifindTheme.body,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: 50,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SportifindTheme.bluePurple,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: BorderRadius.circular(5.0),
              value: selectedPlayTime,
              style: SportifindTheme.textWhite,
              isExpanded: true,
              dropdownColor: SportifindTheme.bluePurple,
              items: playTime.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Center(
                      child: Text(
                    items,
                    style: SportifindTheme.textWhite,
                  )),
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
        ),
      ],
    );
  }

  Widget fieldTypePicker(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type of field",
          style: SportifindTheme.body,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SportifindTheme.bluePurple,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: BorderRadius.circular(5.0),
              value: selectedFieldType,
              style: SportifindTheme.textWhite,
              isExpanded: true,
              dropdownColor: SportifindTheme.bluePurple,
              items: typeOfField.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Center(
                    child: Text(
                      items,
                      style: SportifindTheme.textWhite,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  selectedFieldType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Function to build booking Calendar
  Widget bookingCalender(double bookingHeight) {
    print(selectedField);
    return selectedDate != null
        ? SizedBox(
            height: bookingHeight,
            child: BookingCalendar(
              bookingService: BookingService(
                serviceName: 'Mock Service',
                serviceDuration: 30,
                bookingEnd: convertMinutesToDateTime(
                    convertTimeStringToMinutes(widget.stadiumData.closeTime) -
                        30),
                bookingStart: convertMinutesToDateTime(
                    convertTimeStringToMinutes(widget.stadiumData.openTime)),
              ),
              hideBreakTime: false,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'en',
              selectedPlayTime: convertDurationStringToInt(selectedPlayTime),
              selectedStadium: widget.stadiumData.id,
              selectedStadiumOwner: widget.stadiumData.owner,
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
            ))
        : Container(
            width: double.infinity,
            height: 220,
            child: Center(
              child: Text(
                "Please choose a date to continue",
                style: SportifindTheme.body,
              ),
            ),
          );
  }

  int getFirstFields(
      List<FieldData> fields, String selectedFieldType, int selectedField) {
    List<int> numberId = [];
    fields = List.from(widget.stadiumData.fields)
      ..sort((a, b) => a.numberId.compareTo(b.numberId));
    for (var i = 0; i < fields.length; ++i) {
      if (fields[i].type == selectedFieldType) {
        numberId.add(fields[i].numberId);
      }
    }
    if (selectedField != 0 &&
        numberId.every((element) => element != selectedField)) {
      return numberId[0];
    } else if (numberId.any((element) => element == selectedField)) {
      return selectedField;
    } else {
      return -1;
    }
  }

  Widget displayBox(String title, String displayItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SportifindTheme.body,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(width: 3, color: SportifindTheme.bluePurple),
          ),
          child: Container(
            child: Center(
              child: Text(
                displayItem,
                style: SportifindTheme.textBluePurple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedStadium = widget.stadiumData.name;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SportifindTheme.whiteSmoke,
            leading: BackButton(
              color: SportifindTheme.grey,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MatchMainScreen(),
                  ),
                );
              },
            ),
            centerTitle: true,
            title: Text(
              "Create match",
              style: SportifindTheme.sportifindAppBarForFeature,
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayBox(
                    "Selected tean",
                    widget.selectedTeamName,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  displayBox(
                    "Selected stadium",
                    "$selectedStadium stadium",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  fieldTypePicker(40, 75),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      durationPicker(40, 75),
                      const SizedBox(
                        width: 40,
                      ),
                      FieldPicker(
                        func: refreshByField,
                        fields: widget.stadiumData.fields,
                        selectedField: getFirstFields(widget.stadiumData.fields,
                            selectedFieldType, selectedField),
                        selectedFieldType: selectedFieldType,
                        height: 50,
                        width: 125,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  DatePicker(
                    func: refreshByDate,
                    height: 40,
                    width: 175,
                    selectedDate: selectedDate,
                  ),
                  const SizedBox(height: 30),
                  bookingCalender(365),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
