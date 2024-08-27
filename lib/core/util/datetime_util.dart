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

  int convertDurationStringToInt(String durationString) {
    final parts = durationString.split(':');
    final hours = int.parse(parts[0]);
    final minutes =
        int.parse(parts.length > 1 ? parts[1].substring(0, 2) : '00');
    return hours * 60 + minutes;
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

DateTime convertMinutesToDateTime(int totalMinutes, DateTime selectedDate) {
  // Create a DateTime object by adding the total minutes to the start of the day
  DateTime dateTime =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
          .add(Duration(minutes: totalMinutes));

  return dateTime;
}