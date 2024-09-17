import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/datetime_util.dart';
import 'package:sportifind/core/widgets/date_picker.dart';
import 'package:sportifind/features/match/domain/entities/booking_entity.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/presentation/widgets/booking_calendar.dart';
import 'package:sportifind/features/match/presentation/widgets/field_picker.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_field_by_numberid.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_field_schedule.dart';
import 'package:sportifind/features/team/domain/entities/team_entity.dart';
import 'package:sportifind/home/player_home_screen.dart';

class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen({
    super.key,
    required this.stadiumData,
    required this.selectedTeam,
  });

  final StadiumEntity stadiumData;
  final TeamEntity selectedTeam;

  @override
  State<StatefulWidget> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime? selectedDate;
  List<DateTimeRange> bookedSlot = [];
  String selectedPlayTime = '1:00';
  String selectedFieldType = '';
  int? selectedField;
  List<String> typeOfField = [];
  List<FieldEntity> activeFields = [];

  var playTime = [
    '1:00',
    '1:30',
    '2:00',
  ];

  @override
  void initState() {
    super.initState();
    activeFields = widget.stadiumData.fields
        .where((field) => field.status == true)
        .toList()
      ..sort((a, b) => a.numberId.compareTo(b.numberId));
    getFieldType();
    if(activeFields.isNotEmpty) {
      selectedField = activeFields[0].numberId;
      selectedFieldType = activeFields[0].type;
    }
  }

  void getFieldType() {
    String typeField = '';
    for(var i = 0; i < activeFields.length; ++i) {
      if(activeFields[i].type != typeField) {
        typeField = activeFields[i].type;
        typeOfField.add(typeField);
      }
    }
  }

  List<DateTimeRange> generatePauseSlot(int selectedPlayTime) {
    List<DateTimeRange> pauseSlot = [];
    if (selectedPlayTime == 60) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 30,
              selectedDate!),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime),
              selectedDate!),
        ),
      );
    } else if (selectedPlayTime == 90) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 60,
              selectedDate!),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime),
              selectedDate!),
        ),
      );
    } else if (selectedPlayTime == 120) {
      pauseSlot.add(
        DateTimeRange(
          start: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime) - 90,
              selectedDate!),
          end: convertMinutesToDateTime(
              convertTimeStringToMinutes(widget.stadiumData.closeTime),
              selectedDate!),
        ),
      );
    } else {
      return pauseSlot;
    }
    return pauseSlot;
  }

  Future<List<DateTimeRange>> _updateBookingSlot(
      DateTime pickedDate, int selectedField) async {
    bookedSlot.clear();
    final String date = DateFormat.yMd().format(pickedDate);
    FieldEntity field = await UseCaseProvider.getUseCase<GetFieldByNumberid>()
        .call(GetFieldByNumberidParams(
          stadium: widget.stadiumData,
          numberId: selectedField,
        ))
        .then((value) => value.data!);
    List<MatchEntity> matches =
        await UseCaseProvider.getUseCase<GetFieldSchedule>()
            .call(GetFieldScheduleParams(
              date: date,
              field: field,
            ))
            .then((value) => value.data!);
    for (var i = 0; i < matches.length; i++) {
      bookedSlot.add(DateTimeRange(
          start: convertStringToDateTime(matches[i].start, matches[i].date),
          end: convertStringToDateTime(matches[i].end, matches[i].date)));
    }
    return bookedSlot;
  }

  void refreshByDate(DateTime pickedDate) async {
    final newBookSlot = await _updateBookingSlot(pickedDate, selectedField!);
    setState(() {
      selectedDate = pickedDate;
      bookedSlot = newBookSlot;
    });
  }

  void refreshByField(int pickedField) async {
    if (selectedDate == null) {
      setState(() {
        selectedField = pickedField;
      });
    } else {
      final newBookSlot = await _updateBookingSlot(selectedDate!, pickedField);
      setState(() {
        selectedField = pickedField;
        bookedSlot = newBookSlot;
      });
    }
  }

  // Function to build duration dropdown button
  Widget durationPicker() {
    final width = MediaQuery.of(context).size.width;
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
          width: width - 265,
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

  Widget fieldTypePicker() {
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
    return selectedDate != null
        ? SizedBox(
            height: bookingHeight,
            child: BookingCalendar(
              bookingEntity: BookingEntity(
                serviceName: 'Mock Service',
                serviceDuration: 30,
                bookingEnd: convertMinutesToDateTime(
                    convertTimeStringToMinutes(widget.stadiumData.closeTime) -
                        30,
                    selectedDate!),
                bookingStart: convertMinutesToDateTime(
                    convertTimeStringToMinutes(widget.stadiumData.openTime),
                    selectedDate!),
              ),
              hideBreakTime: false,
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'en',
              selectedPlayTime: convertDurationStringToInt(selectedPlayTime),
              selectedStadium: widget.stadiumData,
              selectedTeam: widget.selectedTeam,
              selectedDate: selectedDate!,
              selectedField: selectedField!,
              pauseSlots: generatePauseSlot(
                  convertDurationStringToInt(selectedPlayTime)),
              bookedSlot: bookedSlot = bookedSlot,
              wholeDayIsBookedWidget:
                  const Text('Sorry, for this day everything is booked'),
            ))
        : SizedBox(
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

  int getFirstFields() {
    for (var i = 0; i < activeFields.length; ++i) {
      if (activeFields[i].type == selectedFieldType) {
        selectedField = activeFields[i].numberId;
        break;
      }
    }
    return selectedField ?? -1;
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
          child: Center(
            child: Text(
              displayItem,
              style: SportifindTheme.textBluePurple,
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
            backgroundColor: SportifindTheme.backgroundColor,
            leading: IconButton(
              color: SportifindTheme.bluePurple,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerHomeScreen(),
                  ),
                );
              },
            ),
            centerTitle: true,
            title: Text(
              "Create match",
              style: SportifindTheme.sportifindAppBarForFeature,
            ),
            elevation: 0,
            surfaceTintColor: SportifindTheme.backgroundColor,
          ),
          backgroundColor: SportifindTheme.backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayBox(
                    "Selected team",
                    widget.selectedTeam.name,
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
                  fieldTypePicker(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      durationPicker(),
                      const SizedBox(
                        width: 40,
                      ),
                      FieldPicker(
                        func: refreshByField,
                        fields: activeFields,
                        selectedField: getFirstFields(),
                        selectedFieldType: selectedFieldType,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  DatePicker(
                    func: refreshByDate,
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
