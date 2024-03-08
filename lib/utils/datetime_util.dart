
import 'package:intl/intl.dart';


class DateTimeUtil {

  static String getYearStr(DateTime dateTime) {
    return dateTime.year.toString();
  }

  static String getMonthStr(DateTime dateTime, {bool? hasZero = false}) {
    return dateTime.month < 10
        ? '${hasZero == true ? '0' : ''}${dateTime.month}'
        : dateTime.month.toString();
  }

  static String getDayStr(DateTime dateTime, {bool? hasZero = false}) {
    return dateTime.day < 10
        ? '${hasZero == true ? '0' : ''}${dateTime.day}'
        : dateTime.day.toString();
  }

  static String getHourStr(DateTime dateTime, {bool? hasZero = false}) {
    return dateTime.hour < 10
        ? '${hasZero == true ? '0' : ''}${dateTime.hour}'
        : dateTime.hour.toString();
  }

  static String getMinuteStr(DateTime dateTime, {bool? hasZero = false}) {
    return dateTime.minute < 10
        ? '${hasZero == true ? '0' : ''}${dateTime.minute}'
        : dateTime.minute.toString();
  }

  static String getSecondStr(DateTime dateTime, {bool? hasZero = false}) {
    return dateTime.second < 10
        ? '${hasZero == true ? '0' : ''}${dateTime.second}'
        : dateTime.second.toString();
  }

  static String getWeekDay(DateTime dateTime) {
    var weekday = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
    return weekday[dateTime.weekday - 1];
  }

  static int getCurrentMonthDays(DateTime dateTime) {
    var year = dateTime.year;
    var month = dateTime.month;
    if (month == 2) {
      //判断2月份是闰年月还是平年
      if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) {
      return 31;
    } else {
      return 30;
    }
  }
  // 判断是否是今天
  static bool isToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy年M月d日').format(date);
  }

}
