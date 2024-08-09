import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportifind/models/match_card.dart';
import '../screens/booking_calendar_main.dart';
import '/models/booking_service.dart';
import 'booking_controller.dart';

class BookingCalendar extends StatelessWidget {
  const BookingCalendar({
    super.key,
    required this.bookingService,
    required this.selectedPlayTime,
    required this.selectedStadium,
    required this.selectedStadiumOwner,
    required this.selectedTeam,
    required this.selectedTeamAvatar,
    required this.selectedDate,
    required this.selectedField,
    required this.bookedSlot,
    required this.addMatchCard,
    this.bookingExplanation,
    this.bookingGridCrossAxisCount,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.bookingButtonText,
    this.bookingButtonColor,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.selectedSlotText,
    this.availableSlotText,
    this.availableSlotTextStyle,
    this.selectedSlotTextStyle,
    this.bookedSlotTextStyle,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
    this.uploadingWidget,
    this.wholeDayIsBookedWidget,
    this.pauseSlotColor,
    this.pauseSlotText,
    this.pauseSlots,
    this.hideBreakTime,
    this.locale,
    this.disabledDays,
    this.disabledDates,
    this.lastDay,
  });

  ///for the Calendar picker we use: [TableCalendar]
  ///credit: https://pub.dev/packages/table_calendar

  ///initial [BookingService] which contains the details of the service,
  ///and this service will get additional two parameters:
  ///the [BookingService.bookingStart] and [BookingService.bookingEnd] date of the booking
  final BookingService bookingService;

  ///this will be display above the Booking Slots, which can be used to give the user
  ///extra informations of the booking calendar (like Colors: default)
  final Widget? bookingExplanation;

  ///For the Booking Calendar Grid System, how many columns should be in the [GridView]
  final int? bookingGridCrossAxisCount;

  ///For the Booking Calendar Grid System, the aspect ratio of the elements in the [GridView]
  final double? bookingGridChildAspectRatio;

  ///The elements in the [GridView] will be [DateTime] texts
  ///and you can format with the help of this parameter
  final String Function(DateTime dt)? formatDateTime;

  ///The text on the booking button
  final String? bookingButtonText;

  ///The color of the booking button
  final Color? bookingButtonColor;

  ///The [Color] and the [Text] of the
  ///already booked, currently selected, yet available slot (or slot for the break time)
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;
  final TextStyle? bookedSlotTextStyle;
  final TextStyle? availableSlotTextStyle;
  final TextStyle? selectedSlotTextStyle;

  ///The [ScrollPhysics] of the [GridView] which shows the Booking Calendar
  final ScrollPhysics? gridScrollPhysics;

  ///Display your custom loading widget while fetching data from [Stream]
  final Widget? loadingWidget;

  ///Display your custom error widget if any error recurred while fetching data from [Stream]
  final Widget? errorWidget;

  ///Display your custom  widget while uploading data to your database
  final Widget? uploadingWidget;

  ///Display your custom  widget if every slot is booked and you want to show something special
  ///not only the red slots
  final Widget? wholeDayIsBookedWidget;

  ///The pause time, where the slots won't be available
  final List<DateTimeRange>? pauseSlots;

  ///True if you want to hide your break time from the calendar, and the explanation text as well
  final bool? hideBreakTime;

  ///for localizing the calendar, String code to locale property. (intl format) See: [https://pub.dev/packages/table_calendar#locale]
  final String? locale;

  ///The days inside this list, won't be available in the calendar. Similarly to [DateTime.weekday] property, a week starts with Monday, which has the value 1. (Sunday=7)
  ///if you pass a number which includes "Today" as well, the first and focused day in the calendar will be the first available day after today
  final List<int>? disabledDays;

  ///The last date which can be picked in the calendar, everything after this will be disabled
  final DateTime? lastDay;

  ///Concrete List of dates when the day is unavailable, eg: holiday, everything is booked or you need to close or something.
  final List<DateTime>? disabledDates;

  final int selectedPlayTime;
  final String selectedTeam;
  final String selectedTeamAvatar;
  final String selectedStadium;
  final String selectedStadiumOwner;
  final DateTime selectedDate;
  final int selectedField;
  final List<DateTimeRange>? bookedSlot;
  final void Function(MatchCard matchcard) addMatchCard;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: BookingController(
        bookingService: bookingService,
        pauseSlots: pauseSlots,
        selectedStadium: selectedStadium,
        selectedStadiumOwner: selectedStadiumOwner,
        selectedTeamId: selectedTeam,
        selectedTeamAvatar: selectedTeamAvatar,
        addMatchCard: addMatchCard,
        bookedTime: bookedSlot!,
        selectedDate: selectedDate,
        selectedField: selectedField,
      ),
      child: BookingCalendarMain(
        key: key,
        bookingButtonColor: bookingButtonColor,
        bookingButtonText: bookingButtonText,
        bookingExplanation: bookingExplanation,
        bookingGridChildAspectRatio: bookingGridChildAspectRatio,
        formatDateTime: formatDateTime,
        bookedSlotTextStyle: bookedSlotTextStyle,
        availableSlotTextStyle: availableSlotTextStyle,
        selectedSlotTextStyle: selectedSlotTextStyle,
        availableSlotColor: availableSlotColor,
        availableSlotText: availableSlotText,
        bookedSlotColor: bookedSlotColor,
        bookedSlotText: bookedSlotText,
        selectedSlotColor: selectedSlotColor,
        selectedSlotText: selectedSlotText,
        gridScrollPhysics: gridScrollPhysics,
        loadingWidget: loadingWidget,
        errorWidget: errorWidget,
        uploadingWidget: uploadingWidget,
        wholeDayIsBookedWidget: wholeDayIsBookedWidget,
        pauseSlotColor: pauseSlotColor,
        pauseSlotText: pauseSlotText,
        hideBreakTime: hideBreakTime,
        locale: locale,
        disabledDays: disabledDays,
        lastDay: lastDay,
        disabledDates: disabledDates,
        selectedPlayTime: selectedPlayTime,
        selectedStadium: selectedStadium,
        selectedTeam: selectedTeam,
        selectedDate: selectedDate,
        bookedSlot: bookedSlot!,
        addMatchCard: addMatchCard,
      ),
    );
  }
}
