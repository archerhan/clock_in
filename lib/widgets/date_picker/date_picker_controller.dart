
import 'package:clock_in/utils/datetime_util.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  var hours = [];
  var mins = [];
  var years = [];
  var months = [];
  var days = [].obs;
  var selectYear = DateTimeUtil.getYearStr(DateTime.now());
  var selectMonth = DateTimeUtil.getMonthStr(DateTime.now(), hasZero: true);
  var selectDay = DateTimeUtil.getDayStr(DateTime.now(), hasZero: true);
  int previousIndex = 0;

  @override
  void onInit() {
    years = _yearsStringListGenerator(2010, 2100);
    months = _numStringListGenerator(12, isStartFromZero: false);
    setDays(int.parse(selectYear), int.parse(selectMonth));
    hours = _numStringListGenerator(24);
    mins = _numStringListGenerator(60);
    previousIndex = months.indexWhere((element) => element == selectMonth);
    super.onInit();
  }

  List<String> _numStringListGenerator(int maxNum,
      {bool? isStartFromZero = true}) {
    int start = isStartFromZero == true ? 0 : 1;
    var list = <String>[];
    for (var i = 0 + start; i < maxNum + start; i++) {
      list.add(i < 10 ? '0$i' : i.toString());
    }
    return list;
  }

  List<String> _yearsStringListGenerator(int from, int to) {
    var list = <String>[];
    for (var i = from; i < to + 1; i++) {
      list.add(i.toString());
    }
    return list;
  }

  // 获取当前月份天数
  int getCurrentMonthDays(int year, int month) {
    if (month == 2) {
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

  setDays(int selectYear, int selectMonth) {
    days.clear();
    for (int i = 1; i < getCurrentMonthDays(selectYear, selectMonth) + 1; i++) {
      days.add(i > 9 ? i.toString() : '0$i');
    }
    days.refresh();
  }

  /// 跨年逻辑
  void updateYear(int index) {
    // 下一年
    if (previousIndex == 11 && index == 0) {
      selectYear = (int.parse(selectYear) + 1).toString();
    }
    // 上一年
    if (previousIndex == 0 && index == 11) {
      selectYear = (int.parse(selectYear) - 1).toString();
    }
    previousIndex = index;
  }
}
