import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportifind/models/match_card.dart';

import '../widgets/booking_controller.dart';
import '../util/booking_util.dart';
import '../widgets/booking_dialog.dart';
import '../widgets/booking_explanation.dart';
import '../widgets/booking_slot.dart';
import '../widgets/common_button.dart';

class BookingCalendarMain extends StatefulWidget {
  const BookingCalendarMain({
    super.key,
    this.bookingExplanation,
    this.bookingGridChildAspectRatio,
    this.formatDateTime,
    this.bookingButtonText,
    this.bookingButtonColor,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.bookedSlotText,
    this.bookedSlotTextStyle,
    this.selectedSlotText,
    this.selectedSlotTextStyle,
    this.availableSlotText,
    this.availableSlotTextStyle,
    this.gridScrollPhysics,
    this.loadingWidget,
    this.errorWidget,
    this.uploadingWidget,
    this.wholeDayIsBookedWidget,
    this.pauseSlotColor,
    this.pauseSlotText,
    this.hideBreakTime = false,
    this.locale,
    this.disabledDays,
    this.disabledDates,
    this.lastDay,
    required this.selectedPlayTime,
    required this.selectedStadium,
    required this.selectedTeam,
    required this.selectedDate,
    required this.bookedSlot,
    required this.addMatchCard,
  });

  ///Customizable
  final Widget? bookingExplanation;
  final double? bookingGridChildAspectRatio;
  final String Function(DateTime dt)? formatDateTime;
  final String? bookingButtonText;
  final Color? bookingButtonColor;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;

//Added optional TextStyle to available, booked and selected cards.
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;

  final TextStyle? bookedSlotTextStyle;
  final TextStyle? availableSlotTextStyle;
  final TextStyle? selectedSlotTextStyle;

  final ScrollPhysics? gridScrollPhysics;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? uploadingWidget;

  final bool? hideBreakTime;
  final DateTime? lastDay;
  final String? locale;
  final List<int>? disabledDays;
  final List<DateTime>? disabledDates;

  final Widget? wholeDayIsBookedWidget;

  // Duration
  final int selectedPlayTime;
  // Selected Team
  final String selectedTeam;
  // Selected Stadium
  final String selectedStadium;
  // Selected Date
  final DateTime selectedDate;
  // get bookedSlot
  final List<DateTimeRange> bookedSlot;
  final void Function(MatchCard matchcard) addMatchCard;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<BookingController>();
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<BookingController>();
    controller.generateBookedSlots(widget.bookedSlot);

    return Consumer<BookingController>(
      builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: (controller.isUploading)
            ? widget.uploadingWidget ?? const BookingDialog()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    // child: (widget.wholeDayIsBookedWidget != null &&
                    //         controller.isWholeDayBooked())
                    //     ? widget.wholeDayIsBookedWidget! :
                    child: GridView.builder(
                      physics: widget.gridScrollPhysics ??
                          const BouncingScrollPhysics(),
                      itemCount: controller.allBookingSlots.length,
                      itemBuilder: (context, index) {
                        TextStyle? getTextStyle() {
                          if (controller.isSlotBooked(index)) {
                            return widget.bookedSlotTextStyle;
                          } else if (index == controller.selectedSlot) {
                            return widget.selectedSlotTextStyle;
                          } else {
                            return widget.availableSlotTextStyle;
                          }
                        }

                        final slot =
                            controller.allBookingSlots.elementAt(index);
                        return BookingSlot(
                          hideBreakSlot: widget.hideBreakTime,
                          pauseSlotColor: widget.pauseSlotColor,
                          availableSlotColor: widget.availableSlotColor,
                          bookedSlotColor: widget.bookedSlotColor,
                          selectedSlotColor: widget.selectedSlotColor,
                          isPauseTime: controller.isSlotInPauseTime(index, widget.selectedPlayTime),
                          isBooked: controller.isSlotBooked(index),
                          isSelected: index == controller.selectedSlot,
                          onTap: () => controller.selectSlot(index),
                          child: Center(
                            child: Text(
                              widget.formatDateTime?.call(slot) ??
                                  BookingUtil.formatDateTime(slot),
                              style: getTextStyle(),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 120,
                        childAspectRatio:
                            widget.bookingGridChildAspectRatio ?? 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  widget.bookingExplanation ??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BookingExplanation(
                              color: widget.availableSlotColor ??
                                  Colors.greenAccent,
                              text: widget.availableSlotText ?? "Available"),
                          BookingExplanation(
                              color: widget.selectedSlotColor ??
                                  Colors.orangeAccent,
                              text: widget.selectedSlotText ?? "Selected"),
                          BookingExplanation(
                              color: widget.bookedSlotColor ?? Colors.redAccent,
                              text: widget.bookedSlotText ?? "Booked"),
                          BookingExplanation(
                              color: widget.pauseSlotColor ??
                                  const Color.fromARGB(255, 71, 71, 71),
                              text: widget.pauseSlotText ?? "Pause"),
                        ],
                      ),
                  const SizedBox(height: 16),
                  CommonButton(
                    text: widget.bookingButtonText ?? 'Create Match',
                    onTap: () async {
                      //controller.toggleUploading();
                      final newBooking =
                          controller.generateNewBookingForUploading(
                              widget.selectedPlayTime);
                      //controller.toggleUploading();
                      controller.resetSelectedSlot();
                      controller.addData(newBooking, widget.selectedPlayTime);
                      controller.returnToMainScreen(context);
                    },
                    isDisabled: controller.selectedSlot == -1,
                    buttonActiveColor: widget.bookingButtonColor,
                  ),
                ],
              ),
      ),
    );
  }
}
