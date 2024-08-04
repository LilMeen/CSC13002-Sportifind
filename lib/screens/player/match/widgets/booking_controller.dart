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
    required this.selectedStadiumOwner,
    required this.selectedTeamId,
    required this.selectedTeamAvatar,
    required this.addMatchCard,
    required this.bookedTime,
    required this.selectedDate,
    required this.selectedField,
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

  final String selectedTeamId;
  final String selectedTeamAvatar;
  final String selectedStadium;
  final DateTime selectedDate;
  final String selectedStadiumOwner;
  final String selectedField;
  final void Function(MatchCard matchcard) addMatchCard;
  final user = FirebaseAuth.instance.currentUser!;

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

  bool isSlotInPauseTime(int index, int selectedPlayTime) {
    DateTime slot = allBookingSlots.elementAt(index);
    bool result = false;
    if (pauseSlots == null) {
      return result;
    }
    for (var pauseSlot in pauseSlots!) {
      if (BookingUtil.isOverLapping(pauseSlot.start, pauseSlot.end, slot,
          slot.add(Duration(minutes: bookingService.serviceDuration)))) {
        result = true;
        return result;
      }
    }
    if (selectedPlayTime == 60) {
      if (index == 0 &&
          isSlotBooked(index + 1) == true &&
          isSlotBooked(index) == false) {
        result = true;
        return result;
      } else if (index != 0 &&
          isSlotBooked(index - 1) == true &&
          isSlotBooked(index + 1) == true &&
          isSlotBooked(index) == false) {
        result = true;
        return result;
      } else if (index != 0 &&
          isSlotBooked(index - 1) == false &&
          isSlotBooked(index + 1) == true &&
          isSlotBooked(index) == false) {
        result = true;
        return result;
      }
    } else if (selectedPlayTime == 90) {
      if (index == 0 &&
          (isSlotBooked(index + 1) == true ||
              isSlotBooked(index + 2) == true) &&
          isSlotBooked(index) == false) {
        result = true;
        return result;
      } else if (index != 0 && isSlotBooked(index) == false && index < 28) {
        for (var i = 1; i <= 2; i++) {
          if (isSlotBooked(index + i) == true) {
            result = true;
            return result;
          }
        }
      }
    } else if (selectedPlayTime == 120) {
      if (index == 0 &&
          (isSlotBooked(index + 1) == true ||
              isSlotBooked(index + 2) == true ||
              isSlotBooked(index + 3) == true) &&
          isSlotBooked(index) == false) {
        result = true;
        return result;
      } else if (index != 0 && isSlotBooked(index) == false && index < 27) {
        for (var i = 1; i <= 3; i++) {
          if (isSlotBooked(index + i) == true) {
            result = true;
            return result;
          }
        }
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
    MatchCard newMatchCard = MatchCard(
      stadium: selectedStadium,
      stadiumOwner: selectedStadiumOwner,
      start: formattedTime.format(bookingDate.bookingStart),
      end: formattedTime.format(bookingDate.bookingEnd),
      date: formatter.format(selectedDate),
      playTime: convertMinutesToDurationString(selectedPlayTime),
      avatarTeam1: selectedTeamAvatar,
      team1: selectedTeamId,
      avatarTeam2: "",
      team2: "",
      field: selectedField,
    );
    addMatchCard(newMatchCard);

    FirebaseFirestore.instance.collection('matches').doc(newMatchCard.id).set({
      'stadium': newMatchCard.stadium,
      'stadiumOwner': newMatchCard.stadiumOwner,
      'start': newMatchCard.start,
      'end': newMatchCard.end,
      'playTime': newMatchCard.playTime,
      'date': newMatchCard.date,
      'team1': newMatchCard.team1,
      'team2': newMatchCard.team2,
      'team1_avatar': newMatchCard.avatarTeam1,
      'team2_avatar': newMatchCard.avatarTeam2,
      'field': selectedField,
    });

    updateTeamsWhereCaptainIsUser(newMatchCard);
  }

  // Assume `user` is already defined and has a `uid` field
  Future<void> updateTeamsWhereCaptainIsUser(MatchCard newMatchCard) async {
    String userUid = user.uid;
    // Reference to the Firestore collection
    CollectionReference teamsCollection =
        FirebaseFirestore.instance.collection('teams');

    // Query to find documents where 'captain' is equal to `user.uid`
    Query query = teamsCollection.where('captain', isEqualTo: userUid);

    // Get the query snapshot
    QuerySnapshot querySnapshot = await query.get();
    List<QueryDocumentSnapshot> doc = querySnapshot.docs;
    DocumentReference docRef = doc[0].reference;
    await docRef.update({
      'incomingMatch.${newMatchCard.id}': false
    });
  }

  void returnToMainScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MatchMainScreen()),
    );
  }
}
