import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportifind/core/theme/sportifind_theme.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  DatePicker({
    super.key,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date",
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showDatePicker();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      widget.selectedDate == null
                          ? 'Selecte Date'
                          : DateFormat.yMd().format(widget.selectedDate!),
                      style: SportifindTheme.textWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
