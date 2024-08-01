import 'package:flutter/material.dart';
import 'package:sportifind/models/match_card.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  DatePicker(
      {super.key,
      this.func,
      required this.height,
      required this.width,
      required this.selectedDate,
      });
  final double height;
  final double width;
  DateTime? selectedDate;
  final dynamic func;

  DateTime get getSlectedDate {
    return selectedDate!;
  }

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 25),
    );
    if (pickedDate != null) {
      setState(() {
        widget.selectedDate = pickedDate;
        widget.func(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Date",
          style: SportifindTheme.display2,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: SportifindTheme.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.selectedDate == null
                    ? 'Selected Date'
                    : formatter.format(widget.selectedDate!),
                style: SportifindTheme.status,
              ),
              IconButton(
                onPressed: () {
                  _showDatePicker();
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
