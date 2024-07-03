import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportifind/models/booking_service.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/screens/player/match/screens/match_main_screen.dart';
import 'package:sportifind/screens/player/match/util/booking_util.dart';
import 'package:flutter/material.dart';

class BookingController extends ChangeNotifier {
  BookingService bookingService;
  BookingController({
    required this.bookingService,
    this.pauseSlots,
    required this.selectedStadium,
    required this.selectedTeam,
    required this.addMatchCard,
    required this.bookedTime,
    required this.selectedDate,
  }) {
    serviceOpening = bookingService.bookingStart;
    serviceClosing = bookingService.bookingEnd;
    pauseSlots = pauseSlots;
    if (serviceOpening!.isAfter(serviceClosing!)) {
      throw "Service closing must be after opening";
    }
    base = serviceOpening!;
    _generateBookingSlots();
  }

  late DateTime base;

  final String selectedTeam;
  final String selectedStadium;
  final DateTime selectedDate;
  final void Function(MatchCard matchcard) addMatchCard;

  DateTime? serviceOpening;
  DateTime? serviceClosing;

  List<DateTime> _allBookingSlots = [];
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedTime;
  List<DateTimeRange> bookedSlots = [];
  List<DateTimeRange>? pauseSlots = [];

  int _selectedSlot = (-1);
  bool _isUploading = false;

  int get selectedSlot => _selectedSlot;
  bool get isUploading => _isUploading;

  bool _successfullUploaded = false;
  bool get isSuccessfullUploaded => _successfullUploaded;

  void initBack() {
    _isUploading = false;
    _successfullUploaded = false;
  }

  void selectFirstDayByHoliday(DateTime first, DateTime firstEnd) {
    serviceOpening = first;
    serviceClosing = firstEnd;
    base = first;
    _generateBookingSlots();
  }

  void _generateBookingSlots() {
    allBookingSlots.clear();
    _allBookingSlots = List.generate(
        _maxServiceFitInADay(),
        (index) => base
            .add(Duration(minutes: bookingService.serviceDuration) * index));
  }

  bool isWholeDayBooked() {
    bool isBooked = true;
    for (var i = 0; i < allBookingSlots.length; i++) {
      if (!isSlotBooked(i)) {
        isBooked = false;
        break;
      }
    }
    return isBooked;
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;
    if (serviceOpening != null && serviceClosing != null) {
      openingHours = DateTimeRange(start: serviceOpening!, end: serviceClosing!)
          .duration
          .inHours;
    }

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / bookingService.serviceDuration).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (BookingUtil.isOverLapping(slot.start, slot.end, checkSlot,
          checkSlot.add(Duration(minutes: bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }

  void selectSlot(int idx) {
    _selectedSlot = idx;
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = -1;
    notifyListeners();
  }

  // void toggleUploading() {
  //   _isUploading = !_isUploading;
  //   notifyListeners();
  // }

  void generateBookedSlots(List<DateTimeRange> data) {
    bookedSlots.clear();
    _generateBookingSlots();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bookedSlots.add(item);
    }
  }

  String convertMinutesToDurationString(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    return '$hours${hours > 0 ? ':' : ''}$minutesStr';
  }

  BookingService generateNewBookingForUploading(int selectedPlayTime) {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    bookingService
      ..bookingStart = (bookingDate)
      ..bookingEnd = (bookingDate.add(Duration(minutes: selectedPlayTime)));
    return bookingService;
  }

  void addData(BookingService bookingDate, int selectedPlayTime) {
    final user = FirebaseAuth.instance.currentUser!;
    MatchCard newMatchCard = MatchCard(
      stadium: selectedStadium,
      startHour: formattedTime.format(bookingDate.bookingStart),
      endHour: formattedTime.format(bookingDate.bookingEnd),
      date: selectedDate,
      playTime: convertMinutesToDurationString(selectedPlayTime),
      avatarTeam1: 'lib/assets/logo/real_madrid.png',
      team1: selectedTeam,
      avatarTeam2: 'lib/assets/logo/logo.png',
      team2: "?",
      userId: user.uid,
    );
    addMatchCard(newMatchCard);

    FirebaseFirestore.instance.collection('matches').doc(newMatchCard.id).set({
      'stadium': newMatchCard.stadium,
      'startHour': newMatchCard.startHour,
      'endHour': newMatchCard.endHour,
      'playTime': newMatchCard.playTime,
      'date': newMatchCard.date,
      'leftTeamName': newMatchCard.team1,
      'rightTeamName': newMatchCard.team2,
      'leftTeamAvatar': newMatchCard.avatarTeam1,
      'rightTeamAvatar': newMatchCard.avatarTeam2,
      'userId': user.uid,
    });
  }

  void returnToMainScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MatchMainScreen()),
    );
  }

  bool isSlotInPauseTime(DateTime slot) {
    bool result = false;
    if (pauseSlots == null) {
      return result;
    }
    for (var pauseSlot in pauseSlots!) {
      if (BookingUtil.isOverLapping(pauseSlot.start, pauseSlot.end, slot,
          slot.add(Duration(minutes: bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }
}
