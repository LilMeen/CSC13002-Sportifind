  import 'package:intl/intl.dart';
  
  DateTime convertStringToDateTime(String timeString, String selectedDate) {
    final hourFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('M/D/yyyy');
    final time = hourFormat.parse(timeString);
    final date = dateFormat.parse(selectedDate);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  
  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');

    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  DateTime parseDateTime(String date, String hour) {
    final dateFormat = DateFormat('M/d/yyyy HH:mm');

    final dateTimeString = '$date $hour';

    return dateFormat.parse(dateTimeString);
  }

  double timeToDouble(String hour) {
    List<String> parts = hour.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return hours + (minutes / 60);
  }