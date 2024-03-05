class DateTimeUtil {
  // 判断是否是今天
  static bool isToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    return now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day;
  }
}