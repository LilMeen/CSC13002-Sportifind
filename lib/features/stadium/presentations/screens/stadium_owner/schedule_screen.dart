import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';
import 'package:sportifind/core/usecases/usecase_provider.dart';
import 'package:sportifind/core/util/datetime_util.dart';
import 'package:sportifind/core/widgets/app_bar/flutter_app_bar_blue_purple.dart';
import 'package:sportifind/core/widgets/general_dropdown.dart';
import 'package:sportifind/features/match/domain/entities/match_entity.dart';
import 'package:sportifind/features/match/domain/usecases/get_match_by_field.dart';
import 'package:sportifind/features/match/domain/usecases/get_match_by_stadium.dart';
import 'package:sportifind/features/match/presentation/screens/match_info_screen.dart';
import 'package:sportifind/features/stadium/domain/entities/field_entity.dart';
import 'package:sportifind/features/stadium/domain/entities/stadium_entity.dart';
import 'package:sportifind/features/stadium/domain/usecases/get_stadiums_by_owner.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  double defaultOpenTime = 7;
  double defaultCloseTime = 23;

  late double stadiumOpenTime;
  late double stadiumCloseTime;

  List<StadiumEntity> stadiums = [];
  List<MatchEntity> matches = [];
  List<Color> bookedColors = [
    SportifindTheme.shovelKnight,
    SportifindTheme.blueOyster,
    SportifindTheme.bluePurple,
    SportifindTheme.clearPurple
  ];

  Map<String, int> fieldMap = {};

  String _selectedStadiumName = '';
  String _selectedFieldName = '';
  StadiumEntity? _selectedStadium;
  FieldEntity? _selectedField;

  bool isLoadingStadiums = true;
  String errorMessage = '';


  Future<void> fetchStadiumData() async {
    try {
      List<StadiumEntity> stadiumsData = await UseCaseProvider.getUseCase<GetStadiumsByOwner>().call(
        GetStadiumsByOwnerParams(ownerId: FirebaseAuth.instance.currentUser!.uid),
      ).then((value) => value.data ?? []);
      setState(() {
        stadiums = stadiumsData;
        isLoadingStadiums = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load stadium data: $error';
        isLoadingStadiums = false;
      });
    }
  }

  Future<void> updateData() async {
    try {
      if (_selectedStadiumName.isNotEmpty && _selectedFieldName.isNotEmpty) {
        List<MatchEntity> matchesData = await UseCaseProvider.getUseCase<GetMatchByField>().call(
          GetMatchByFieldParams(fieldId: _selectedField!.id),
        ).then((value) => value.data ?? []);
        setState(() {
          stadiumOpenTime = timeToDouble(_selectedStadium!.openTime).floorToDouble();
          stadiumCloseTime = timeToDouble(_selectedStadium!.closeTime).ceilToDouble();
          fieldMap = {_selectedField!.id: _selectedField!.numberId};
          matches = matchesData;
        });
      } else if (_selectedStadiumName.isNotEmpty) {
        List<MatchEntity> matchesData = await UseCaseProvider.getUseCase<GetMatchByStadium>().call(
          GetMatchByStadiumParams(stadiumId: _selectedStadium!.id),
        ).then((value) => value.data ?? []);
        setState(() {
          stadiumOpenTime = timeToDouble(_selectedStadium!.openTime).floorToDouble();
          stadiumCloseTime = timeToDouble(_selectedStadium!.closeTime).ceilToDouble();
          fieldMap = {for (var field in _selectedStadium!.fields) field.id: field.numberId};
          matches = matchesData;
          matches.sort((a, b) => a.field.numberId.compareTo(b.field.numberId));
        });
      } else {
        setState(() {
          stadiumOpenTime = defaultOpenTime;
          stadiumCloseTime = defaultCloseTime;
          fieldMap = {};
          matches.clear();
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load match data: ${error.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _refreshStadiums() async {
    setState(() {
      isLoadingStadiums = true;
      errorMessage = '';
    });
    await fetchStadiumData();
    await updateData();
  }

  @override
  void initState() {
    super.initState();
    fetchStadiumData();
    stadiumOpenTime = defaultOpenTime;
    stadiumCloseTime = defaultCloseTime;
  }

  Widget _buildStadiumDropdown() {
    List<String> stadiumNames = [];
    if (stadiums.isNotEmpty) {
      stadiumNames = stadiums.map((stadium) => stadium.name).toList();
    }

    return GeneralDropdown(
      selectedValue: _selectedStadiumName,
      hint: 'Select stadium',
      items: stadiumNames,
      fillColor: SportifindTheme.backgroundColor,
      onChanged: (value) {
        setState(() {
          _selectedStadiumName = value ?? '';
          if (_selectedStadiumName.isNotEmpty) {
            _selectedStadium = stadiums
                .firstWhere((stadium) => stadium.name == _selectedStadiumName);
          } else {
            _selectedStadium = null;
          }

          _selectedFieldName = '';
          _selectedField = null;
          updateData();
        });
      },
    );
  }

  Widget _buildFieldDropdown() {
    List<String> fieldNames = [];
    List<FieldEntity> fields = [];

    if (_selectedStadiumName.isNotEmpty &&
        _selectedStadium!.fields.isNotEmpty) {
      fields = _selectedStadium!.fields
        ..sort((a, b) => a.numberId.compareTo(b.numberId));
      fieldNames = fields.map((field) => 'Field ${field.numberId}').toList();
    }

    return GeneralDropdown(
      selectedValue: _selectedFieldName,
      hint: 'Select field',
      items: fieldNames,
      fillColor: SportifindTheme.backgroundColor,
      onChanged: (value) async {
        setState(() {
          _selectedFieldName = value ?? '';
          if (_selectedFieldName.isNotEmpty) {
            _selectedField = fields.firstWhere(
                (field) => 'Field ${field.numberId}' == _selectedFieldName);
          } else {
            _selectedField = null;
          }
        });
        updateData();
      },
    );
  }

  List<Appointment> _getDataSource() {
    List<Appointment> meetings = <Appointment>[];
    meetings = matches.map((match) {
      final startTime = parseDateTime(match.date, match.start);
      final endTime = parseDateTime(match.date, match.end);
      return Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: 'Booked',
        notes: match.id,
        color: bookedColors[(match.field.numberId - 1) % bookedColors.length],
      );
    }).toList();

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingStadiums) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _refreshStadiums,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: SportifindTheme.bluePurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshStadiums,
      child: Scaffold(
        appBar: const FeatureAppBarBluePurple(title: 'Schedule'),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: _buildStadiumDropdown()),
                  const SizedBox(width: 8.0),
                  Expanded(child: _buildFieldDropdown()),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: SfCalendar(
                view: CalendarView.week,
                firstDayOfWeek: 1,
                todayHighlightColor: SportifindTheme.bluePurple,
                headerStyle: CalendarHeaderStyle(
                  backgroundColor: SportifindTheme.bluePurple,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 196, 153, 243),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeFormat: "HH:mm",
                  startHour: stadiumOpenTime,
                  endHour: stadiumCloseTime,
                  timeIntervalHeight: 50,
                ),
                dataSource: MeetingDataSource(_getDataSource()),
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month
                ],
                showNavigationArrow: true,
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.appointment &&
                      details.appointments != null) {
                    Appointment tappedAppointment = details.appointments!.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchInfoScreen(
                            matchInfo: matches.firstWhere(
                                (match) => match.id == tappedAppointment.notes),
                            matchStatus: 3),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
