// ignore_for_file: file_names

import 'package:admin_perpustakaan/utils/log_utils.dart';
import 'package:intl/intl.dart';

class Time {
  final _now = DateTime.now();

  String getTimeNow() {
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_now);
    log("formattedDate", v: formattedDate); // 2016-01-25
    return formattedDate;
  }

  int getDate() {
    return _now.day;
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
    return _now.month;
  }

  int getYear() {
    return _now.year;
  }

  int getLastDateInMonth() {
    var lastDayDateTime = (_now.month < 12)
        ? DateTime(_now.year, _now.month + 1, 0)
        : DateTime(_now.year + 1, 1, 0);
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
