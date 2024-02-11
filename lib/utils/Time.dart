// ignore_for_file: file_names

import 'package:intl/intl.dart';

class Time {
  final now = DateTime.now();

  String getTimeNow() {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String getTimeNowHour() {
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  int getDate() {
    return now.day;
  }

  List<int> getDateByRange(int range) {
    var getDate = this.getDate() + range;
    var month = getMonth();

    if (getDate > getLastDateInMonth()) {
      getDate = getDate - getLastDateInMonth();
      month += 1;
    }
    return [getDate, month];
  }

  List<int> getDateByRangeIndex(int range, int index) {
    var getDate = index + range;

    var month = getMonth();

    if (getDate > getLastDateInMonth()) {
      getDate = getDate - getLastDateInMonth();
      month += 1;
    }

    return [getDate, month];
  }

  int getMonth() {
    return now.month;
  }

  int getYear() {
    return now.year;
  }

  int getHour() {
    return now.hour;
  }

  int getMinute() {
    return now.minute;
  }

  int getLastDateInMonth() {
    var lastDayDateTime = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);
    return lastDayDateTime.day;
  }

  int getDateBeforeByRange(day, range) {
    final d1 = getLastDateInMonth() + int.parse(day);
    final d2 = getLastDateInMonth() + range;
    return d1.toInt() - d2.toInt();
  }

  int getJumlahHariDate(int year, int month, int date) {
    DateTime currentDate = DateTime.now();
    // DateTime currentDate = DateTime(2023, 9, 25);
    DateTime targetDate = DateTime(year, month, date);
    Duration difference = targetDate.difference(currentDate);
    return difference.inDays;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
