import 'package:intl/intl.dart';

class Time {
  final _now = DateTime.now();

  String getTimeNow() {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(_now);
    print(formattedDate); // 2016-01-25
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
        ? new DateTime(_now.year, _now.month + 1, 0)
        : new DateTime(_now.year + 1, 1, 0);
    return lastDayDateTime.day;
  }

  int getDateBeforeByRange(day, range) {
    final d1 = getLastDateInMonth() + int.parse(day);
    final d2 = getLastDateInMonth() + range;
    return d1.toInt() - d2.toInt();
  }
}
